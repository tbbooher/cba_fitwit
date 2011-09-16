FactoryGirl.define do
  factory :order_transaction do
    action 'authorization'
    amount 100
    success 'true'
    reference ''
  end

  factory :successful_authorization do
    order 'authorized'
    reference '123'
    message 'The transaction was successful'
  end

  factory :authorization_with_failing_reference do
    order 'uncapturable'
    reference '2'
    message 'The transaction was successful'
  end

  factory :authorization_with_error_reference do
    order 'uncapturable_error'
    reference '1'
    message 'The transaction was successful'
  end

  factory :authorization_for_subscription do
    order 'subscription_test'
    amount '1300'
    reference '123'
    message 'This is a transaction for a subscription'
  end
end