require 'spec_helper'

describe CouponCode do
  before(:all) do
    cleanup_database
    @coupon = FactoryGirl.create(:coupon_code)
  end

  it "should be expired after it's expiration date" do
    @coupon.expires_at = 10.days.ago
    @coupon.save
    @coupon.expired?.should == true
  end

  it "should be live if it is active not expired and not used up" do
    @coupon.expires_at = 10.days.from_now
    @coupon.live?.should == true
  end

  it "should be used up if it is past it's max number" do
    @coupon.uses = 11
    @coupon.used_up?.should == true
  end

end
