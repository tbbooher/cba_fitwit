=begin
Now that there is a place for the remote integration tests, let's add a few of them. We're going to write tests that verify that the Order model functions correctly when the OrderTransaction model is configured
to send requests to the payment gateway's test environment. Obviously, the tests presented aren't exhaustive. There many additional
cases that you'd want to cover in your real application.
Let's write tests that test following basic scenarios: successful authorization,
unsuccessful authorization, successful authorization and capture, and unsuccessful capture.
=end
require File.dirname(__FILE__) + '/../../test_helper'
class OrderIntegrationTest < ActiveSupport::TestCase
  def setup
    OrderTransaction.gateway = CyberSourceGateway.new(
        :login => 'v9526006',
        :password => 'ETkK7MmfB/7ZVF6wCtLxPsLtFwUgMkLW0AtH/kOuKpSaoME8zZuxWdYZdLnmK1+O8lgP5VEW7UYghSc4lTjgGd/GaTHFu9IcrohPSYrUH7W1+WCXpZXbGqgRobrUUToLnGTlVcUsQPb0bGh+Ud7KOb4TIQxKBfRfvVM5WUtPCbwUXuLcpsgxNHmOXrAK0vE+wu0XBSAyQtbQC0f+Q64qlJqgwTzNm7FZ1hl0ueYrX47yWA/lURbtRiCFJziVOOAZ38ZpMcW70hyuiE9JitQftbX5YJelldsaqBGhutRROgucZOVVxSxA9vRsaH5R3so5vhMhDEoF9F+9UzlZS08JvA==',
        :test => true,
        :vat_reg_number => 111,
        :nexus => "GA", # sets the states/provinces where you have a physical presense for tax purposes
        :ignore_avs => true, # don‘t want to use AVS so continue processing even if AVS would have failed
        :ignore_cvv => true # don‘t want to use CVV so continue processing even if CVV would have failed
    )
    @order = FactoryGirl.create(:pending)
    @credit_card = credit_card(:number => '4111111111111111')
    # need to add card type
    @options = {:description => 'A store purchase',
                :billing_address => address,
                :email => 'foo@foo.com'
    }
  end

  def test_successful_order_authorization
    assert_difference '@order.order_transactions.count' do
      authorization = @order.authorize_payment(@credit_card, @options)
      assert_equal authorization.reference,
                   @order.authorization_reference
      assert authorization.success?
      assert @order.authorized?
    end
  end

  def test_authorization_unsuccessful_with_invalid_credit_card_number
    @credit_card.number = 'invalid'
    assert_difference '@order.order_transactions.count' do
      authorization = @order.authorize_payment(@credit_card, @options)
      assert_nil @order.authorization_reference
      assert !authorization.success?
      assert @order.payment_declined?
    end
  end

  def test_successful_authorization_and_capture
    assert_difference '@order.order_transactions.count', 2 do
      authorization = @order.authorize_payment(@credit_card, @options)
      assert authorization.success?
      assert @order.authorized?
      capture = @order.capture_payment
      assert capture.success?
      assert @order.paid?
    end
  end

  def test_authorization_and_unsuccessful_capture
    assert_difference '@order.order_transactions.count', 2 do
      authorization = @order.authorize_payment(@credit_card, @options)
      assert authorization.success?
      assert @order.authorized?
      authorization_transaction = @order.order_transactions.first
      authorization_transaction.update_attribute(:reference, '')
      capture = @order.capture_payment
      assert !capture.success?
      assert @order.authorized?
    end
  end
end