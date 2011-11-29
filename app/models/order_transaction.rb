class OrderTransaction
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount, :type => Integer
  field :success, :type => Boolean
  field :reference, :type => String
  field :message, :type => String
  field :action, :type => String
  field :params, :type => Hash
  field :test, :type => Boolean

  belongs_to :order
  #serialize :params
  cattr_accessor :gateway

  #ActiveMerchant

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

    def generate_yearly_subscription(credit_card, options = {})
      number_of_payments = 12
      amount_per_payment = 115.00

      @subscription_options = {
          :order_id => options[:order_id],
          :email => options[:email],
          :credit_card => credit_card,
          :billing_address => options[:address],
          :setup_fee => 50,
          :subscription => {
              :frequency => "monthly",
              :start_date => Date.today.end_of_month,
              :occurrences => number_of_payments,
              :auto_renew => true,
              :amount => amount_per_payment.to_s
          }
      }

      # do we need to send this an amount?
      process('subscription') do |gw|
        gw.create_subscription(credit_card, @subscription_options)
      end
    end

    private

    def process(action, amount = nil)
      result = OrderTransaction.new
      result.amount = amount
      result.action = action

      begin
        response = yield gateway

        result.success = response.success?
        result.reference = response.authorization
        result.message = response.message
        result.params = response.params
        result.test = response.test?
      rescue ActiveMerchant::ActiveMerchantError => e
        result.success = false
        result.reference = nil
        result.message = e.message
        result.params = {}
        result.test = gateway.test?
      end

      result
    end
  end
end
