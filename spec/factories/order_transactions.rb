FactoryGirl.define do 
factory :order_transaction, :class => OrderTransaction do
  action 'authorization'
  amount 100
  success true
  reference ''
end

factory :successful_authorization, :class => OrderTransaction do
  action "authorization"
  order "authorized"
  amount "100"
  success true
  reference "123"
  message "The transaction was successful"
end

factory :authorization_with_failing_reference, :class => OrderTransaction do
  action "authorization"
  order "uncapturable"
  amount "100"
  success true
  reference "2"
  message "The transaction was successful"
end

factory :authorization_with_error_reference, :class => OrderTransaction do
  action "authorization"
  #order { FactoryGirl.create(:uncapturable_error) }
  amount "100"
  success true
  reference 1
  message "The transaction was successful"
end

factory :authorization_for_subscription, :class => OrderTransaction do
  order 'subscription_test'
  amount '1300'
  reference '123'
  message 'This is a transaction for a subscription'
end
end
