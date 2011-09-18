Factory.define :order_transaction, :class => OrderTransaction do |o|
  o.action 'authorization'
  o.amount 100
  o.success 'true'
  o.reference ''
end

Factory.define :successful_authorization, :class => OrderTransaction do |o|
  o.order 'authorized'
  o.reference '123'
  o.message 'The transaction was successful'
end

Factory.define :authorization_with_failing_reference, :class => OrderTransaction do |o|
  o.order 'uncapturable'
  o.reference '2'
  o.message 'The transaction was successful'
end

Factory.define :authorization_with_error_reference, :class => OrderTransaction do |o|
  o.order 'uncapturable_error'
  o.reference '1'
  o.message 'The transaction was successful'
end

Factory.define :authorization_for_subscription, :class => OrderTransaction do |o|
  o.order 'subscription_test'
  o.amount '1300'
  o.reference '123'
  o.message 'This is a transaction for a subscription'
end