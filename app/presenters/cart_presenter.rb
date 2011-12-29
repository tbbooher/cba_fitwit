class CartPresenter < BasePresenter

  presents :cart # registration stuff

  def show_cart
    render partial: "fitness_camp_registration/cart/cart", object: cart
  end

  def fit_wit_history(user)
    render partial: "my_fit_wit/includes/fit_wit_history", locals: {user: user}
  end

  def membership_info(user)
    unless cart.new_membership
      render partial: "fitness_camp_registration/cart/cart_includes/price_info", locals: {user: user}
    else
      h.content_tag(:p,"Congratulations on your selection of a FitWit membership!")
      h.content_tag(:p,"In addition to your new membership, you are registering for the following classes:")
    end
  end

  def show_camps(cart_items)
    render :partial => "fitness_camp_registration/cart/cart_includes/cart_item", :collection => cart_items
  end

end
