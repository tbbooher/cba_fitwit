FactoryGirl.define do
  factory :order do 
    user {User.first}
    amount 100
  end

  factory :pending, :class => Order do 
    description "pending order"
    user {User.first}
    amount 100
    state 'pending'
  end

  factory :authorized, :class => Order do 
    description 'authorized order'
    user {User.first}
    amount 100
    state 'authorized'
  end

  factory :uncapturable, :class => Order do 
    user {User.first}
    description 'authorized, but uncapturable'
    amount 100
    state 'authorized'
  end

  factory :uncapturable_error, :class => Order  do 
    user {User.first}
    description 'authorized, but uncapturable due to error'
    amount 101
    state 'authorized'
    order_transactions {|ot| [ot.association(:authorization_with_error_reference)]}
    #association :order_transactions, :factory => :authorization_with_error_reference
    #order_transactions { FactoryGirl.build(:authorization_with_error_reference) }
  end

  factory :subscription_test, :class => Order  do 
    user {User.first}
    description 'this is an order for a subscription'
    amount '1300'
    state 'authorized'
  end
end
