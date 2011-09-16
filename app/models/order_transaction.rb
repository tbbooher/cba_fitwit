class OrderTransaction
  include Mongoid::Document
  include Mongoid::Timestamps

  # field :order_id, :type => Integer relation
  field :amount, :type => Integer
  field :success, :type => Boolean
  field :reference, :type => String
  field :message, :type => String
  field :action, :type => String
  field :params, :type => Hash
  field :test, :type => Boolean
  #field :created_at, :type => Datetime
  #field :updated_at, :type => Datetime

  belongs_to :order
  #serialize :params
  cattr_accessor :gateway
 
  class << self
    def authorize(amount, credit_card, options = {})
      process('authorization', amount) do |gw|
        gw.authorize(amount, credit_card, options)
      end
    end
    
    def capture(amount, authorization, options = {})
      process('capture', amount) do |gw|
        gw.capture(amount, authorization, options)
      end
    end

    def generate_subscription(credit_card, options = {})
      number_of_payments = 12
      amount_per_payment = 115.00
      options[:frequency] = "monthly"  # string
      options[:numberOfPayments] = number_of_payments # integer
      options[:amount] = amount_per_payment.to_s      # string
      options[:startDate] = Date.today.end_of_month.strftime("%Y%m%d") # tomorrow?
      options[:currency] = "USD"
      options[:automaticRenew] = "false"   # integer in form YYYYMMDD
      
      # recurringSubscriptionInfo_startDate:
      
      setup_fee = 50 # in dollars
      options[:item_0_unitPrice] = setup_fee.to_s
      # grand_total_amount is in cents
#      grand_total_amount = (number_of_payments*amount_per_payment+setup_fee)*100
      grand_total_amount = (50)*100
      
      process('subscription', grand_total_amount) do |gw|
        gw.create_installment(grand_total_amount, credit_card, options)
      end
    end
    
    private
    
    def process(action, amount = nil)
      result = OrderTransaction.new
      result.amount = amount
      result.action = action
    
      begin
        response = yield gateway
    
        result.success   = response.success?
        result.reference = response.authorization
        result.message   = response.message
        result.params    = response.params
        result.test      = response.test?
      rescue ActiveMerchant::ActiveMerchantError => e
        result.success   = false
        result.reference = nil
        result.message   = e.message
        result.params    = {}
        result.test      = gateway.test?
      end
      
      result
    end
  end
end
