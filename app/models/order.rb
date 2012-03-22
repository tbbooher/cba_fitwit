require 'rubygems'
require 'stateflow'

# No persistence
Stateflow.persistence = :mongoid

class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  field :amount, :type => Integer # in cents
  field :state, :type => String, default: "pending"
  field :description, :type => String

  has_many :registrations, :dependent => :destroy
  has_many :order_transactions,
           :class_name => 'OrderTransaction',
           :dependent => :destroy
  belongs_to :user
  # belongs_to :cart
  # belongs_to :coupon_code # , :counter_cache => :uses
  # serialize :params
  # we don't need this
  # field :hash_params, type: Hash
  # field :array_params, type: Array

  cattr_accessor :gateway

  # ...

  #  PAYMENT_TYPES = [
  #    #  Displayed        stored in db
  #    [ "Check",          "check" ],
  #    [ "Credit card",    "cc"   ],
  #    [ "Purchase order", "po" ]
  #  ]
  # |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  # validations
  # |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

  validates_presence_of :user_id, :amount, :description
  validates_numericality_of :amount
  #validates_format_of :expiration_mo, :with => /^\d{2}$/, :message => "must be two digit year"
  #validates_inclusion_of :payment_method, :in => PAYMENT_TYPES.map {|disp, value| value}
  def self.card_types
    {'Visa' => 'visa',
     'MasterCard' => 'master',
     'Discover' => 'discover',
     'American Express' => 'american_express'}
  end

  #  cardtypes = [ :visa, :master, :american_express, :diners_club, :jcb, :switch, :solo, :maestro ]
  # |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  # FROM PEEPCODE
  # |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  # BEGIN acts_as_state_machine

  stateflow do
    initial :pending

    state :pending, :authorized, :paid, :payment_declined

    event :payment_authorized do
      transitions :from => :pending,
                  :to => :authorized

      transitions :from => :payment_declined,
                  :to => :authorized
    end

    event :payment_captured do
      transitions :from => :authorized,
                  :to => :paid
    end

    event :transaction_declined do
      transitions :from => :pending,
                  :to => :payment_declined

      transitions :from => :payment_declined,
                  :to => :payment_declined

      transitions :from => :authorized,
                  :to => :authorized
    end
  end
  # END acts_as_state_machine

  # BEGIN authorization_reference
  def authorization_reference
    if authorization = self.order_transactions.where(action: 'authorization').and(success: true).asc(:id).first
      authorization.reference
    end
  end

  # END authorization_reference

  # BEGIN number
  def number
    # TODO have this be our order id 
    #CGI::Session.generate_unique_id
    mydate = Date.today().strftime('%Y%m%d')
    "#{self.user.last_name}_#{mydate}_#{self.id}"
  end

  # END number

  # BEGIN authorize_payment
  def authorize_payment(credit_card, options = {})

    # this is the major function that interacts with the credit card company
    options[:order_id] = number # currently just loading a date
                                #    options[:email] = 'developer@fitwit.com'
                                #    options[:billing_address] = {
                                #      :name => 'Cody Fauser',
                                #      :address1 => '1234 Shady Brook Lane',
                                #      :address2 => 'Apartment 1',
                                #      :city => 'Ottawa',
                                #      :state => 'ON',
                                #      :country => 'CA',
                                #      :zip => 'K3P5N5',
                                #      :phone => '999-999-9999'}

    authorization = OrderTransaction.authorize(amount, credit_card, options)
    self.save!
    self.order_transactions << authorization

    if authorization.success?
      self.payment_authorized!
    else
      self.transaction_declined!
    end

    authorization
    #end
  end

  # END authorize_payment

  # BEGIN capture_payment
  def capture_payment(options = {})
    # transaction do
    capture = OrderTransaction.capture(amount, authorization_reference, options)
    self.save!
    self.order_transactions << capture

    if capture.success?
      self.payment_captured!
    else
      self.transaction_declined!
    end

    capture
    # end
  end

  # END capture_payment

  # foray into the world of subscriptions (profiles)
  def create_subscription(credit_card, options = {})

    u = self.user
    options[:order_id] = number # currently just loading a date
    options[:email] = u.email
    options[:address] = {
        :first_name => u.first_name,
        :last_name => u.last_name,
        :address1 => u.street_address1,
        :address2 => (u.street_address2 || ""),
        :company => (u.company || ""),
        :city => u.city,
        :state => u.us_state,
        :zip => u.zip,
        :country => 'United States',
        :phone => u.primary_phone
    }

    subscription = OrderTransaction.generate_yearly_subscription(credit_card, options)
    self.save!
    order_transactions << subscription

    if subscription.success?
      self.payment_captured!
    else
      self.transaction_declined!
    end

    subscription
  end

  # |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  # END FROM PEEPCODE
  # |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

  def register_timeslots_from_cart(cart, user)
    # this is the big transfer of info from the non-persistent cart
    # to the persistent registration store
    # orders are really just to record cash transactions -- the goal
    # is not to use them in the daily operation of the site for workout tracking, etc
    # Registration becomes the key record to connect items
    registration_errors = []
    cart.items.each do |item|
      rs = Registration.new
      # a user is now joining this location
      user.location_id = item.time_slot.fitness_camp.location.id
      user.save
      rs.user_id = user.id
      #rs.fitness_camp_id = item.time_slot.fitness_camp.id
      rs.time_slot_id = item.time_slot.id
      rs.order_id = self.id
      rs.payment_arrangement = item.payment_arrangement
      case item.payment_arrangement
        when :pay_by_session
          rs.number_of_sessions = item.number_of_sessions
        when :initial_member
          # josh, doesn't need this feature right now
        else # traditional payment for the camp
          rs.number_of_sessions = nil
          rs.price_paid = item.camp_price_for_(user)
      end
      unless item.coupon_discount == 0
        rs.coupon_discount = item.coupon_discount
        rs.coupon_code = item.coupon_code
      end
      rs.friends = item.friends.join(",")
      unless rs.save!
        # TODO need to test!!
        errors.add_to_base(rs.errors.messages)
      end
    end # items
  end

  def complete_camp_purchase(params, user, cart)
    credit_card_params = params.except(:billing_address)
    billing_address = params[:billing_address]
    update_user_information(user, billing_address)
    credit_card = ActiveMerchant::Billing::CreditCard.new(credit_card_params)
    purchase_errors = []
    if credit_card.valid?
      # this is very lame
      options = build_options(user, billing_address[:us_state],billing_address[:zip],billing_address[:city],billing_address[:address1],billing_address[:address2])
      result_msg = authorize(credit_card, options)
      if result_msg == "success"
        # send relevant emails
        send_emails(user, cart)
        # update user information based on what they submitted
        # actually put them in a camp, this should return nil if successful
        registration_errors = self.register_timeslots_from_cart(cart, user)
        unless registration_errors
          # empty the cart
          session[:cart] = nil
          unless capture = @order.capture_payment
            purchase_errors = [capture]
          end
        end
      else
        purchase_errors = [result_msg]
      end
    else
      purchase_errors = "Credit Card not Valid: " + credit_card.errors.full_messages.to_sentence
    end
    purchase_errors # no errors means success
  end

  private

  def authorize(credit_card, options)
    if self.authorize_payment(credit_card, options).success?
      "success"
    else
      # " authorization failed "
      purchase.message + "<br>" + purchase.params['missingField'].to_s
    end
  end

  def send_emails(user, cart)
    Notifications.inform_management_about_a_new_user(user,
      cart,
      self).deliver
    Notifications.inform_customer_about_their_new_journey(user,
      cart).deliver
  end

  #def send_membership_emails(user, cart)
  #  inform_management = Postman.create_inform_ben_membership(user,
  #    self,
  #    params[:credit_card],
  #    session[:health_approval],
  #    cart)
  #  inform_customer = Postman.create_inform_user_membership(user,
  #    self,
  #    params[:credit_card],
  #    session[:health_approval],
  #    cart)
  #  Postman.deliver(inform_management)
  #  Postman.deliver(inform_customer)
  #end

  def build_options(u, state = nil, zip = nil, city = nil, address1 = nil, address2 = nil)
    # this is my attempt at populating the options hash for the credit card
    {
      :email => u.email,
      :billing_address => {
        :name => u.full_name,
        :address1 => address1 || u.street_address1,
        :address2 => address2 || u.street_address2,
        :city => city || u.city,
        :state => state || u.us_state,
        :country => 'US',
        :zip => zip || u.zip,
        :phone => u.primary_phone}
    }
  end

  def update_user_information(user, billing_address)
    user.first_name = billing_address[:first_name] unless billing_address[:first_name].blank?
    user.last_name =  billing_address[:last_name] unless billing_address[:last_name].blank?
    user.street_address1 =  billing_address[:street_address1] unless billing_address[:street_address1].blank?
    user.street_address2 =  billing_address[:street_address2] unless billing_address[:street_address2].blank?
    user.city =  billing_address[:city] unless billing_address[:city].blank?
    user.us_state = billing_address[:us_state] unless billing_address[:us_state].blank?
    user.zip = billing_address[:zip] unless billing_address[:zip].blank?
    user.save!
  end

end
