Factory.define :order_transaction, :class => OrderTransaction do |o|
  o.action 'authorization'
  o.amount 100
  o.success true
  o.reference ''
end

Factory.define :successful_authorization, :class => OrderTransaction do |o|
  o.action "authorization"
  o.order "authorized"
  o.amount "100"
  o.success true
  o.reference "123"
  o.message "The transaction was successful"
end

Factory.define :authorization_with_failing_reference, :class => OrderTransaction do |o|
  o.action "authorization"
  o.order "uncapturable"
  o.amount "100"
  o.success true
  o.reference "2"
  o.message "The transaction was successful"
end

Factory.define :authorization_with_error_reference, :class => OrderTransaction do |o|
  o.action "authorization"
  #o.order { FactoryGirl.create(:uncapturable_error) }
  o.amount "100"
  o.success true
  o.reference 1
  o.message "The transaction was successful"
end

Factory.define :authorization_for_subscription, :class => OrderTransaction do |o|
  o.order 'subscription_test'
  o.amount '1300'
  o.reference '123'
  o.message 'This is a transaction for a subscription'
end