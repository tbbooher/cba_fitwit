require File.dirname(__FILE__) + '/../test_helper'

require 'rubygems'
require 'mocha'

class FitwitRegistrationControllerTest < ActionController::TestCase

  def setup
    User.destroy_all
    @controller = FitwitRegistrationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_reject_user_who_answered_yes_and_did_not_enter_information
    user = login_as(:user_with_membership)
    post :save_order, :health_approval => {:participation_approved => 'Yes',
      :taking_medications => 'Yes',
      :post_menopausal_female => 'No',
      :taking_estrogen => 'No'}
    l = RAILS_DEFAULT_LOGGER
    #l.debug(@response.inspect)
    l.info(@response.flash.to_yaml)
    assert flash[:issues_to_resolve] == "true", "incorrect flash"
    assert_response :redirect, "not success was redirected to #{@response.redirected_to.to_yaml}"
    assert_redirected_to(:action => 'consent')
  end

  def test_should_accept_user_who_answered_no
    user = login_as(:user_with_membership)
    post :save_order, :health_approval => {:participation_approved => 'Yes',
      :taking_medications => 'No',
      :post_menopausal_female => 'No',
      :taking_estrogen => 'No'}
    l = RAILS_DEFAULT_LOGGER
    l.info('----------------------------')
    order = assigns["order"]
    l.info(@response.flash.to_yaml)
    assert_redirected_to(:action => 'payment', :id => order.id)
  end

  def test_should_load_consent_page
    user = login_as(:user_without_membership)
    add_cart_with_items
    get :consent
    assert :success, "page didn't load successfully"
  end

  def test_should_ensure_user_information_is_saved_on_payment
    #login user and populate cart
    user = login_as(:user_without_membership)
    add_cart_with_items
    #    params[:credit_card][:number] = "4111-1111-1111-1111"
    #    params[:credit_card][:year] = "2012"
    #    params[:credit_card][:month] = "12"
    #    params[:billing_address][:zip] = "90210"
    #    :credit_card => {:number => "1", :year => '2008', :month => '12', :type => 'bogus', :last_name => user.last_name, :first_name => user.first_name},
    FitwitRegistrationController.any_instance.stubs(:send_emails).returns(true)
    post :pay, :id => 1,
    :credit_card => credit_card_hash,
    :billing_address => {:zip => "90210" }
    user = User.find(1)
    assert user.zip == '90210', "user zip is '#{user.zip}'"
  end

  def test_that_user_with_membership_should_be_directed_to_no_need_to_register_page
    #    @cart = (session[:cart] ||= Cart.new)
    user = login_as(:user_with_membership)
    add_cart_with_items
    assert user.user_name == "member", "user name is " + user.user_name
    get :view_cart
    assert_redirected_to(:action => 'no_need_to_register')
  end

  def test_add_membership
    login_as(:user_without_membership)
    add_cart_with_items
    post :view_cart, :agree_to_terms => "yes", :commit => "Return to cart"
    assert session[:cart].new_membership, "new membership was not assigned the value 'true'"
  end

  def test_should_deny_consent_to_user_with_an_empty_cart
    #flunk("still need to write")
  end

  def test_membership_info_should_return_to_cart_if_checked
    login_as(:user_without_membership)
    add_cart_with_items
    get :membership_info
    assert_response :success, "sent to #{@response.redirected_to.to_yaml}"
    # now we need to test the return to cart
    post :view_cart, :agree_to_terms => "yes", :commit => "Return to cart"
    assert_response :success
  end

  def test_should_show_that_membership_info_doesnt_load_for_non_logged_in_user
    get :membership_info
    #    assert_redirected_to(:action => 'no_need_to_register')
    assert_redirected_to(:controller => "login", :action => "login")
  end

  def test_should_show_membership_information_in_cart
    login_as(:user_without_membership)
    add_cart_with_items
    get :view_cart
    assert_select "title","FitWit::View FitWit Cart", "wrong title"
    assert_response :success
  end

  def test_should_ensure_membership_added_when_referred_by_membership_info
    login_as(:user_without_membership)
    @cart = Cart.new
    @cart.add_timeslot(TimeSlot.find(:first))
    assert @cart.total_items == 1
    @request.session[:cart] = @cart
    post :view_cart, :agree_to_terms => "yes", :commit => "Return to cart"
    # now we want to ensure that the user can view the correct
    # membership information
    assert session[:cart].new_membership, "new membership was not assigned the value 'true'"
    assert assigns(:cart).total_items == 1, "total item count is #{assigns(:cart).total_items}"
    # is the user displaying financial info
    assert_select "div.financial_info"
  end

  def test_should_show_empty_cart_if_cart_is_empty
    # we need to mock the cart so that it is nil
    login_as(:user_without_membership)
    @cart = Cart.new
    @request.session[:cart] = @cart
    get :view_cart
  end

  def test_should_redirect_user_with_empty_cart_from_certain_views
    # first create a empty cart eieio
    login_as(:user_without_membership)
    @cart = Cart.new
    @request.session[:cart] = @cart
    lists = [:view_cart, :consent, :payment]
    lists.each do |view|
      get view
      assert_response :redirect, "sent to #{@response.redirected_to}"
      #     assert @response.redirected_to == "actionall_fitness_camps"
      assert_redirected_to :controller => "fitwit_registration", :action => "all_fitness_camps"
    end
  end

  def test_should_redirect_user_who_does_not_click_agree_but_submits_membership_info
    login_as(:user_without_membership)
    add_cart_with_items
    # load the view_cart view without clicking the form
    post :view_cart, :commit => "Return to cart"
    assert_redirected_to :action => "membership_info"
  end

  def test_should_not_save_order_after_consent_submission_if_not_all_items_submitted
    login_as(:user_without_membership)
    # need to ensure the user is redirected
    post :save_order
    myflash = @request.session["flash"]
    assert !myflash.nil?,"flash empty"
    assert_redirected_to :action => 'consent'
  end

  def test_should_save_order_after_consent_submission_if_all_items_submitted
    FitwitRegistrationController.any_instance.stubs(:not_assigned?).returns(false)
    FitwitRegistrationController.any_instance.stubs(:user_has_issues?).returns(false)
    login_as(:user_without_membership)
    # need to ensure the user is redirected
    post :save_order
    # we must create a stub for not_assigned?(int_gender,
    # params[:health_approval])
    # we want to test the flash . . .
    assert_redirected_to :action => :payment
  end

  #   def test_should_redirect_users_who_do_not_click_on_agree_to_terms
  #     login_as(:user_without_membership)
  #     @cart = Cart.new
  #     post :save_order
  #     #flunk('need to finish')
  #   end

  def test_should_display_index
    get :index, :id => 5
    assert_response :success
  end

  def test_create_profile
    #params[:id] = 1
    assert true
  end

end
