module FitnessCampRegistrationHelper

  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block);
  end

  def p
    "fitness_camp_registration/cart_includes/view_cart/"
  end

  def display_cc_errors(cc_err)
    # TODO still needed?? -- don't these come from active_merchant?
    out = "Please correct the following:"
    out += "<ul>\n"
    cc_err.each do |value|
      out += "<li>#{value}</li>\n"
    end
    out += "</ul>"
  end

  def vet_savings(vet_status)
    if vet_status == 1
      savings = PRICE['first_time']-PRICE['veteran']
    else
      savings = PRICE['first_time']-PRICE['super_vet']
    end
    number_to_currency(savings)
  end

  #  def vet_discount_category(vet_status)
  #    (vet_status == 1) ? 2 : 3
  #  end

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

  def fitness_camp_price(vet_status, ci, has_membership)
    friend_count = ci.friends.size
    pay_by_session = ci.pay_by_session
    number_of_sessions = ci.number_of_sessions
    # begin price logic

    unless has_membership
      if vet_status == 0
	    if @cart.coupon_code
			  price = @cart.coupon_code.price
        elsif friend_count > 0
          # 319
          price = PRICE['first_time']-PRICE['friend_discount']['virgin']
        else # no friend
          # 359
          price = PRICE['first_time']
        end # friend_check
      else # we have a vet
        if pay_by_session
          #price = session_price[number_of_sessions]
          price = PRICE['pay_by_session'][number_of_sessions]
	    elsif @cart.coupon_code
			  price = @cart.coupon_code.price
        else # pay for the whole thing
          if vet_status == 2
            # price: 199
            price = PRICE['super_vet']
          else # regular vet
            price = PRICE['veteran'] - PRICE['friend_discount']['vet']*[friend_count, PRICE['friend_discount']['max_vet_friends']].min
          end
        end
      end # vet check
    else # this guy has got a membership, no cost
      price = 0
    end
    price
  end

  def display_chance_to_toggle_session(blnPayBySession,cart_index)
    if blnPayBySession # they are paying by session
      s = 'Naturally, you can still pay for all sessions '
      a = 'Pay for camp'
    else
      s = 'Otherwise, as a vet, you can also pay by session '
      a = 'Pay by session'
    end
    out = '<div>'
    out += s
    out += submit_tag(a,
                      :name => "pay_by_session[#{cart_index}]",
                      :class => 'button')
    out += '</div>'
  end

  def display_standard_price
    out = "<span class=\"price_desc\">Standard price is</span>\n"
    out += "<span class=\"price\">#{number_to_currency(PRICE['first_time'])}</span>\n"
    out += "<div style=\"clear:both;\"></div>"
    out
  end

end
