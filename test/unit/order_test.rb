require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # BEGIN authorization_tests
  # need to bring in Factory Girl
  def setup
    User.delete_all
    user = Factory(:admin)
    @pending_order = Factory.build(:pending)
  end

  def test_successful_order_authorization
    order = @pending_order

    credit_card = credit_card(:number => '1')

    assert_difference 'order.order_transactions.size' do
      authorization = order.authorize_payment(credit_card)
      assert_equal authorization.reference, order.authorization_reference
      assert authorization.success?
      assert order.authorized?
    end
  end

  def test_failed_order_authorization
    order = @pending_order
    credit_card = credit_card(:number => '2')

    assert_difference 'order.transactions.count' do
      authorization = order.authorize_payment(credit_card)
      assert_nil order.authorization_reference
      assert !authorization.success?
      assert order.payment_declined?
    end
  end

  def test_exception_raised_during_authorization
    order = @pending_order
    credit_card = credit_card(:number => '3')

    assert_difference 'order.transactions.count' do
      authorization = order.authorize_payment(credit_card)
      assert_nil order.authorization_reference
      assert !authorization.success?
      assert order.payment_declined?
    end
  end
  # END authorization_tests

  # BEGIN capture_tests
  def test_successful_payment_capture
    order = FactoryGirl.build(:authorized)

    assert_difference 'order.transactions.count' do
      capture = order.capture_payment
      assert order.paid?
      assert capture.success?
    end
  end

  def test_failed_payment_capture
    order = FactoryGirl.build(:uncapturable)

    assert_difference 'order.transactions.count' do
      capture = order.capture_payment
      assert order.authorized?
      assert !capture.success?
    end
  end

  def test_error_during_payment_capture
    order = FactoryGirl.build(:uncapturable_error)

    assert_difference 'order.transactions.count' do
      capture = order.capture_payment
      assert order.authorized?
      assert !capture.success?
    end
  end
  # END capture_tests

  # now let's test subscriptions
  def test_order_subscriptions
    order = FactoryGirl.build(:subscription_test)
    credit_card = credit_card(:number => '4111 1111 1111 1111')

    assert_difference 'order.transactions.count' do
#      capture = order.capture_payment
      capture = order.create_subscription(credit_card)
      #assert order.authorized?
      assert capture.success?
    end
  end

end
