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
