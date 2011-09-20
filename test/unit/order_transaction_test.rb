require File.dirname(__FILE__) + '/../test_helper'

class OrderTransactionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
# BEGIN test_authorization
  def setup
    @amount = 100
  end
  
  def test_successful_authorization
    auth = OrderTransaction.authorize(
              @amount, 
              credit_card(:number => '1')
            )
    assert auth.success
    assert_equal 'authorization', auth.action
    assert_equal BogusGateway::SUCCESS_MESSAGE, auth.message
    assert_equal BogusGateway::AUTHORIZATION, auth[:reference]
  end

  def test_failed_authorization
    auth = OrderTransaction.authorize(
              @amount, 
              credit_card(:number => '2')
            )
    assert !auth.success
    assert_equal 'authorization', auth.action
    assert_equal BogusGateway::FAILURE_MESSAGE, auth.message
  end

  def test_exception_during_authorization
    auth = OrderTransaction.authorize(
              @amount, 
              credit_card(:number => '3')
            )
    assert !auth.success
    assert_equal 'authorization', auth.action
    assert_equal BogusGateway::ERROR_MESSAGE, auth.message
  end
  # END test_authorization

  # BEGIN test_capture
  def test_successful_capture
    capt = OrderTransaction.capture(@amount, '123')
    assert capt.success
    assert_equal 'capture', capt.action
    assert_equal BogusGateway::SUCCESS_MESSAGE, capt.message
  end

  def test_failed_capture
    capt = OrderTransaction.capture(@amount, '2')
    assert !capt.success
    assert_equal 'capture', capt.action
    assert_equal BogusGateway::FAILURE_MESSAGE, capt.message
  end

  def test_error_during_capture
    capt = OrderTransaction.capture(@amount, '1')
    assert !capt.success
    assert_equal 'capture', capt.action
    assert_equal BogusGateway::CAPTURE_ERROR_MESSAGE, 
                 capt.message
  end
  # END test_capture
  
  # now we need to test subscriptions
  def test_subscription_payment_transaction
    capt = OrderTransaction.capture(@amount, '123')
    assert capt.success
    assert_equal 'capture', capt.action
    assert_equal BogusGateway::SUCCESS_MESSAGE, capt.message
  end
end
