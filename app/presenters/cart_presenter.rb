class CartPresenter < BasePresenter

  presents :cart # registration stuff

  def show_cart
    render partial: "cart", object: cart
  end

  def fit_wit_history(user)
    render partial: "my_fit_wit/includes/fit_wit_history", locals: {user: user}
  end

  def show_regular_info
    render partial: "fitness_camp_registration/cart_includes/show_vet_info"
  end

  def show_camps(cart_items)
    render :partial => "fitness_camp_registration/cart_includes/cart_item", :collection => cart_items
  end


end
