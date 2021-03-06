class CartItemPresenter < BasePresenter

  presents :cart_item # registration stuff

  PPATH = "fitness_camp_registration/cart/cart_includes/cart_item_includes/"
  UI_BUTTON = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"

  def show_summary_table(user)
    content_tag(:div, "You are currently #{cart_item.show_payment_method_text}.", id: "payment_method_description", style: "margin-bottom:15px;") +
        content_tag(:table, :id => "discounts_table", :class => "table table-striped table-bordered table-condensed") {
          content_tag(:tbody) {
            display_standard_price(user) +
                summary_table_content(user) +
                display_final_price(user)
          }
        }
  end

  def show_tabs(user)
    out = ""
    tabs = ['Membership', 'Traditional', 'Pay by Session']
    [:initial_member, :traditional, :pay_by_session].each_with_index do |tab, i|
      css_class = find_css_class(user, tab)
      out += content_tag(:li, content_tag(:a, tabs[i], href: '#', id: tab.to_s.parameterize, class: 'tab'), class: css_class) unless (user.veteran_status == :newbie && tab == :initial_member)
    end
    out.html_safe
  end

  def find_css_class(user, tab)
    # there could be no payment arrangement
    if user.veteran_status == :newbie # traditional is default
      if cart_item.payment_arrangement
        if tab == cart_item.payment_arrangement
          "current"
        end
      else
        if tab == :traditional
          "current"
        end
      end
    else # membership is default
      if cart_item.payment_arrangement
        if tab == cart_item.payment_arrangement
          "current"
        end
      else
        if tab == :initial_member
          "current"
        end
      end
    end
  end

  def summary_table_content(user)
    case cart_item.payment_arrangement
      when :initial_member
        "initial member"
      when :member
        "member"
      when :staff
        "staff"
      when :pay_by_session
        pay_by_session_row
      else
        display_coupon_discounts + display_friend_discounts(user)
    end
  end

  def pay_by_session_row
    render partial: "fitness_camp_registration/cart/cart_includes/cart_item_includes/pay_by_session_row",
           locals: {session_count: cart_item.number_of_sessions,
                    session_price: PRICE['pay_by_session'][cart_item.number_of_sessions]}
  end

  def show_membership_sign_up
    render "#{PPATH}membership_sign_up"
  end

  def show_option_to_switch_to_traditional
    content_tag :div, id: 'traditional_switch_link' do
      link_to("Switch to traditional", set_traditional_path(cart_item.unique_id), remote: true) unless cart_item.payment_arrangement == :traditional
    end
  end

  def give_option_to_pay_by_session
    content_tag(:div, id: "session_options") do
      (content_tag(:h4, "Select to pay by session") +
          [12, 16, 20].map { |s|
            content_tag(:span, link_to("#{s} Sessions", add_sessions_to_cart_path(s, cart_item.unique_id), remote: true),
                        class: "#{UI_BUTTON} #{cart_item.number_of_sessions.to_i == s.to_i ? "ui-state-hover" : ""}")
          }.join("\n").html_safe
      )
    end
  end

  def show_traditional_options(user)
    content_tag(:div, :id => "discount_forms") {
      (cart_item.coupon_discount > 0 ? "".html_safe : render(partial: "#{PPATH}coupon_discount_form", locals: {cart_item: cart_item})) +
          render(partial: "#{PPATH}friend_discount_form", locals: {cart_item: cart_item})
    }
  end

  def display_final_price(user)
    content_tag(:tr, "<th class='left'>Final Price</td><td id='final_camp_price'>#{number_to_currency(cart_item.camp_price_for_(user)/100)}</td>".html_safe,
                id: 'final_price_row')
  end

  def display_friend_discounts(user)
    render(partial: "#{PPATH}friend_discount_row", collection: cart_item.friends, as: :friend, locals: {savings: PRICE['friend_discount'][user.veteran_status.to_s], cart_item: cart_item})
  end

  def display_coupon_discounts
    if cart_item.coupon_discount > 0
      coupon = CouponCode.find(cart_item.coupon_code_id)
      render partial: "fitness_camp_registration/cart/cart_includes/cart_item_includes/coupon_discount_row", locals: {coupon: coupon}
    else
      "".html_safe
    end
  end

  def display_standard_price(user)
    content_tag(:tr, content_tag(:th, "Standard price:", class: 'left') +
        content_tag(:td, number_to_currency(PRICE['traditional'][user.veteran_status.to_s])), id: 'standard_price')

  end

  def display_coupon_code_discount(coupon_code)
    discount = coupon_code.price
    number_to_currency(discount)
  end

end