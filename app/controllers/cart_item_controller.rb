class CartItemController < ApplicationController
  before_filter :find_cart_item, except: [:get_friend_savings]

  def add_friend
    @new_friend = params[:friend_name]
    @max_friends = PRICE['friend_discount']['max_vet_friends']
    unless @cart_item.friends.size > @max_friends
      @cart_item.friends << @new_friend
      @updated_camp_price = @cart_item.camp_price_for_(@user)/100
    else
      @too_many_friends = true
    end
    @savings = get_friend_savings(@user)
  end

  def remove_friend
    @friend = params[:friend_name]
    @cart_item.friends.delete_if{|f| f == @friend}
    @updated_camp_price =  @cart_item.camp_price_for_(@user)/100
  end

  def set_traditional
    unless @cart_item.payment_arrangement == :traditional
      @cart_item.payment_arrangement = :traditional
      @savings = get_friend_savings(@user)
    if (@cart_item.coupon_discount > 0)
      @coupon = CouponCode.find(@cart_item.coupon_code_id)
    end
      @updated_camp_price =  @cart_item.camp_price_for_(@user)/100
    else
      render nothing: true
    end
  end

  def add_coupon
    @coupon_code = params[:coupon_code]
    @category = 'message msg-error'
    unless @coupon_code.blank?
      if @coupon = CouponCode.where(code: @coupon_code).first
          if !@coupon.live?
            @notice = "Sorry, that code is no longer active"
            @notice = "Sorry, that code has expired" if @coupon.expired?
            @notice = "Sorry, that code has been used the maximum number of times" if @coupon.used_up?
          else
            if @cart_item.coupon_discount > 0
              @notice = "Sorry, only one coupon per camp is allowed."
            else # we can do it!
              # Live coupon code
              @notice = "Coupon code applied!"
              @category = 'message msg-tip'
              @cart_item.coupon_discount = @coupon.price
              @cart_item.coupon_code_id = @coupon.id
              @updated_camp_price = @cart_item.camp_price_for_(@user)/100
            end
          end
      else
        @notice = "That code was not found"
      end
    else
      @notice = "Coupon code can't be blank"
    end

  end

  def add_pay_by_session
    @session_count = params[:number_of_sessions].to_i
    @session_price = PRICE['pay_by_session'][@session_count]
    @cart_item.payment_arrangement = :pay_by_session
    @cart_item.number_of_sessions = @session_count
    @updated_camp_price = @cart_item.camp_price_for_(@user)/100
  end

  def set_payment_arrangement
  end

  private

  def find_cart_item
    @cart_item = session[:cart].items.select{|i| i.unique_id == params[:unique_id]}.first
    @user = current_user
  end

  def get_friend_savings(user)
    PRICE['friend_discount'][user.veteran_status.to_s]
  end

end