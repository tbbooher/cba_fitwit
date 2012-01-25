FactoryGirl.define do

  #field :title, :type => String
  #field :starts_at, :type => DateTime
  #field :ends_at, :type => DateTime
  #field :all_day, :type => Boolean
  #field :description, :type => String

  sequence :starts_at do |n|
    Time.local(2012,02,n,6,0)
  end

  factory :event do
    title "Parkour"
    starts_at Time.local(2012,02,1,6,0)
    ends_at Time.local(2012,02,1,7,0)
    all_day false
    description Faker::Company.bs
    location
  end

end