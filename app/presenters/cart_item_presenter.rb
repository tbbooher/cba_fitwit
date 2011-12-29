class CartItemPresenter < BasePresenter

  presents :cart_item # registration stuff

  PPATH = "fitness_camp_registration/cart_includes/view_cart/"

  def show_vet_options
    if cart_item.pay_by_session
      render "#{PPATH}pay_by_session_form"
    else # pay for whole camp
      render "#{PPATH}coupon_discount_form"
      render(partial: "#{PPATH}friend_discount_form", locals: {cart_item_includes: cart_item})
    end
  end


  def show_friends_discount

  end

  def show_coupon_code_discount

  end

  def display_standard_price
    out = "<span class=\"price_desc\">Standard price is</span>\n"
    out += "<span class=\"price\">#{number_to_currency(PRICE['first_time'])}</span>\n"
    out += "<div style=\"clear:both;\"></div>"
    out
  end

  def display_friend_discount(index, vet_status)
    if vet_status == 0
      if index == 0
        out = number_to_currency(-PRICE['friend_discount']['virgin'])
      else
        out = 'thanks'
      end # index == 0 check
    else
      if index < PRICE['friend_discount']['max_vet_friends']
        out = number_to_currency(-PRICE['friend_discount']['vet'])
      else
        out = 'wow, thanks'
      end
    end
    out
  end

  def display_coupon_code_discount(coupon_code)
    #discount = PRICE['first_time'] - coupon_code.price
    discount = coupon_code.price
    number_to_currency(discount)
  end

end