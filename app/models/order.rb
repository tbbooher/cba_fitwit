require 'rubygems'
require 'stateflow'

# No persistence
Stateflow.persistence = :mongoid

class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  field :amount, :type => Integer
  field :state, :type => String, default: "pending"
  field :description, :type => String

  has_many :registrations, :dependent => :destroy
  has_many :order_transactions,
           :class_name => 'OrderTransaction',
           :dependent => :destroy
  belongs_to :user
  # belongs_to :coupon_code # , :counter_cache => :uses
  # serialize :params TODO -- fix this
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

                                #transaction do

                                # amount is a property of the order

    authorization = OrderTransaction.authorize(amount, credit_card, options)
    self.save!
    self.order_transactions << authorization

    if authorization.success?
      self.payment_authorized!
    else
      self.transaction_declined!
    end

    # testing

    #self.order_transactions.reload

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

  def register_timeslots_from_cart(cart)
    cart.items.each do |item|
      rs = Registration.create(:time_slot_id => item.timeslot.id,
                               :order_id => self.id)
      #        :name_of_friend => item.name_of_friend,
      #        :discount_category => item.discount_category)
      # now add all friends to this registration
      item.friends.each do |friend|
        rs.friends << Friend.create(:name => friend)
      end # friends
      rs.save
      registrations << rs
    end # items
  end

  def register_user_to_time_slot(time_slot_id)
    Registration.create(:time_slot_id => time_slot_id,
                        :order_id => self.id)
  end

  def complete_camp_purchase(params, user, cart)
    credit_card = ActiveMerchant::Billing::CreditCard.new(params[:credit_card])
    if credit_card.valid?
      options = build_options(@user, params[:billing_address][:us_state],params[:billing_address][:zip],params[:billing_address][:city],params[:billing_address][:address1],params[:billing_address][:address2])
      result_msg = authorize(credit_card, options)
      if result_msg == "success"
        # send relevant emails
        send_emails(user, cart)
        # update user information based on what they submitted
        update_user_information(user, params)
        # actually put them in a camp
        self.register_timeslots_from_cart(cart)
        # empty the card
        session[:cart] = nil
        # try to capture the payment
        if @order.capture_payment
          redirect_to fitness_camp_registration_registration_success_path(self.id)
        else
          "Capture Failed"
        end
      else
        @credit_card.errors.full_messages
      end
    end
  end

  private

  def authorize(credit_card, options)
    if self.authorize_payment(credit_card, options).success?
      "success"
    else
      purchase.message + "<br>" + purchase.params['missingField'].to_s
    end
  end

  def send_emails(user, cart)
    inform_management = Postman.create_new_order(user,
      self,
      params[:credit_card],
      session[:health_approval],
      cart)
    inform_customer = Postman.create_inform_customer(user,
      self,
      params[:credit_card],
      session[:health_approval],
      cart)
    Postman.deliver(inform_management)
    Postman.deliver(inform_customer)
  end

  def send_membership_emails(user, cart)
    inform_management = Postman.create_inform_ben_membership(user,
      self,
      params[:credit_card],
      session[:health_approval],
      cart)
    inform_customer = Postman.create_inform_user_membership(user,
      self,
      params[:credit_card],
      session[:health_approval],
      cart)
    Postman.deliver(inform_management)
    Postman.deliver(inform_customer)
  end

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

  def update_user_information(user, params)
    user.first_name = params[:billing_address][:first_name] unless params[:billing_address][:first_name].blank?
    user.last_name =  params[:billing_address][:last_name] unless params[:billing_address][:last_name].blank?
    user.email_address = params[:billing_address][:email_address] unless params[:billing_address][:email_address].blank?
    user.street_address1 =  params[:billing_address][:street_address1] unless params[:billing_address][:street_address1].blank?
    user.street_address2 =  params[:billing_address][:street_address2] unless params[:billing_address][:street_address2].blank?
    user.city =  params[:billing_address][:city] unless params[:billing_address][:city].blank?
    user.us_state = params[:billing_address][:us_state] unless params[:billing_address][:us_state].blank?
    user.zip = params[:billing_address][:zip] unless params[:billing_address][:zip].blank?
    user.save!
  end

end
