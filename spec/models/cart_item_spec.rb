require 'spec_helper'

describe CartItem do
  before(:all) do
    cleanup_database
    @u = FactoryGirl.create(:user)
    @ts = FactoryGirl.create(:time_slot)
    PRICE = YAML.load_file("#{Rails.root}/config/prices.yml")
  end

  it "should be able to display friend count" do
    z = CartItem.new(@ts)
    z.bring_a_friend(Faker::Name.first_name + " " + Faker::Name.last_name)
    z.bring_a_friend(Faker::Name.first_name + " " + Faker::Name.last_name)
    z.bring_a_friend(Faker::Name.first_name + " " + Faker::Name.last_name)
    z.friend_count.should == 3
  end

  it "should be able to charge an initial membership" do
    m = CartItem.new(@ts)
    m.payment_arrangement = :initial_member
    m.camp_price_for_(@u).should == (PRICE['monthly_membership_fee'] + PRICE['setup_fee'])*100
  end

  describe "charge by session" do
    # 12, 16, 20
    s = CartItem.new(@ts)
    s.payment_arrangement = :pay_by_session
    [12,16,20].each do |num_sessions|
      s.number_of_sessions = num_sessions
      s.camp_price_for_(@u).should == PRICE['pay_by_session'][num_sessions]*100
    end
  end

  describe "complete price inputs" do
    before(:each) do
      @c = CartItem.new(@ts)
      @c.payment_arrangement = :traditional
    end
    scenarios = [
      {coupon: 0, friends_count: 0, veteran_status: :veteran, price: 259},
      {coupon: 0, friends_count: 0, veteran_status: :newbie, price: 299},
      {coupon: 0, friends_count: 0, veteran_status: :supervet, price: 219},
      {coupon: 0, friends_count: 1, veteran_status: :veteran, price: 234},
      {coupon: 0, friends_count: 1, veteran_status: :newbie, price: 274},
      {coupon: 0, friends_count: 1, veteran_status: :supervet, price: 219},
      {coupon: 0, friends_count: 2, veteran_status: :veteran, price: 209},
      {coupon: 0, friends_count: 2, veteran_status: :newbie, price: 249},
      {coupon: 0, friends_count: 7, veteran_status: :veteran, price: 109},
      {coupon: 0, friends_count: 7, veteran_status: :newbie, price: 149},
      {coupon: 10, friends_count: 0, veteran_status: :veteran, price: 249},
      {coupon: 10, friends_count: 0, veteran_status: :newbie, price: 289},
      {coupon: 10, friends_count: 0, veteran_status: :supervet, price: 209},
      {coupon: 10, friends_count: 1, veteran_status: :veteran, price: 224},
      {coupon: 10, friends_count: 1, veteran_status: :newbie, price: 264},
      {coupon: 10, friends_count: 1, veteran_status: :supervet, price: 209},
      {coupon: 10, friends_count: 2, veteran_status: :veteran, price: 199},
      {coupon: 10, friends_count: 2, veteran_status: :newbie, price: 239},
      {coupon: 10, friends_count: 7, veteran_status: :veteran, price: 99},
      {coupon: 10, friends_count: 7, veteran_status: :newbie, price: 139}]
    scenarios.each_with_index do |s, index|
      it "should return the price #{s[:price]} for #{s[:veteran_status]} friends: #{s[:friends_count]} with coupon #{s[:coupon]}" do
        1.upto(s[:friends_count]) do
          @c.bring_a_friend(Faker::Name.first_name + " " + Faker::Name.last_name)
        end
        @c.coupon_discount = s[:coupon]*100
        @u.veteran_status = s[:veteran_status].to_sym
        @c.camp_price_for_(@u).should == s[:price]*100
      end
    end
  end

end
