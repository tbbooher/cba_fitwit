FactoryGirl.define do
  factory :order do
    user {User.first}
    amount 100
  end

  factory :pending, :class => Order do
    description "pending order"
    user {User.first}
    state 'pending'
  end

  factory :authorized, :class => Order do
    description 'authorized order'
    user {User.first}
    state 'authorized'
  end

  factory :uncapturable, :class => Order do
    user {User.first}
    description 'authorized, but uncapturable'
    state 'authorized'
  end

  factory :uncapturable_error, :class => Order  do
    user {User.first}
    description 'authorized, but uncapturable due to error'
    state 'authorized'
  end

  factory :subscription_test, :class => Order  do
    user {User.first}
    description 'this is an order for a subscription'
    amount '1300'
    state 'authorized'
  end

end