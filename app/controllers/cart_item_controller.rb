class CartItemController < ApplicationController
  before_filter :find_cart_item
  def add_friend
    @new_friend = params[:friend_name]
    @max_friends = PRICE['friend_discount']['max_vet_friends']
    unless @cart_item.friends.size > @max_friends
      @cart_item.friends << @new_friend
      @updated_camp_price = @cart_item.camp_price(@user)/100
    else
      @too_many_friends = true
    end
    @savings = PRICE['friend_discount'][@user.veteran_status.to_s]
  end

  def remove_friend
    @friend = params[:friend_name]
    @cart_item.friends.delete_if{|f| f == @friend}
    @updated_camp_price =  @cart_item.camp_price(@user)/100
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
              @updated_camp_price = @cart_item.camp_price(@user)/100
            end
          end
      else
        @notice = "That code was not found"
      end
    else
      @notice = "Coupon code can't be blank"
    end

  end

  def remove_coupon
  end

  def set_payment_arrangement
  end

  private

  def find_cart_item
    @cart_item = session[:cart].items.select{|i| i.unique_id == params[:unique_id]}.first
    @user = current_user
  end

end


  #def add_discounts
  #  # need to move this to model -- shouldn't be here
  #  # this function processes the data from our form
  #  if request.post?
  #    if params[:addfriend]
  #      if params[:friends_name].empty?
  #        flash[:notice] = "You must provide a name for your friend"
  #      else
  #        # keys gets the hash values, we want the first as an integer
  #        item_count = params[:addfriend].keys.first.to_i
  #        # we need to save all existing forms
  #        @cart.items[item_count].bring_a_friend(params[:friends_name])
  #      end
  #      redirect_to :action => :view_cart
  #    elsif params[:delfriend]
  #      friend_info = params[:delfriend].keys.first.split('_').collect {|n| n.to_i}
  #      # we need to save all existing forms
  #      @cart.items[friend_info[0]].delete_a_friend(friend_info[1])
  #      redirect_to :action => :view_cart
  #    elsif !params[:coupon_code].blank?
  #      code = CouponCode.find_by_code(params[:coupon_code])
  #      msg = "Sorry, that coupon code was not found."
  #      if code
  #        if !code.live?
  #          msg = "Sorry, that code is no longer active"
  #          msg = "Sorry, that code has expired" if code.expired?
  #          msg = "Sorry, that code has been used the maximum number of times" if code.used_up?
  #        else
  #          # Live coupon code
  #          msg = "Coupon code applied!"
  #          @cart.coupon_code = code
  #        end
  #      end
  #
  #      flash[:notice] = msg
  #      redirect_to :action => :view_cart
  #    elsif params[:pay_by_session]
  #      item_count = params[:pay_by_session].keys.first.to_i
  #      # um, what is going on here?
  #      @cart.items[item_count].pay_by_session = !@cart.items[item_count].pay_by_session
  #      redirect_to :action => :view_cart
  #    elsif params[:define_pay_by_sessions]
  #      session_detail = params[:define_pay_by_sessions].keys.first.split('_').collect{|n| n.to_i}
  #      @cart.items[session_detail[0]].number_of_sessions = session_detail[1]
  #      redirect_to :action => :view_cart
  #    else # let's move on to the next step
  #      if @cart.items.collect{|i| \
  #            [i.pay_by_session, i.number_of_sessions]}.any? {|u, v| u && v == 0}
  #        flash[:notice] = "You need to select a session number"
  #        redirect_to :action => :view_cart
  #      else
  #        @cart.items.each_with_index do |ci, i| # go through each item in cart
  #          price = params["item#{i}"][:price].to_f
  #          # price = fitness_camp_price(previous_camp_count = 0, friend_count = 0, pay_by_session = nil)
  #          ci.price = price
  #        end # cart item iteration
  #        redirect_to :action => :consent
  #      end # total price check
  #    end # params check
  #  end # post check
  #end