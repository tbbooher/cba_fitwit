require 'pp'

class FitnessCampRegistrationController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :add_to_cart, :empty_cart, :view_cart, :all_fitness_camps]
  # must change !!
  #ssl_required  :consent, :save_order, :payment, :pay,
  #   :release_and_waiver_of_liability, :terms_of_participation

  before_filter :find_cart, :except => :empty_cart
  before_filter :ensure_items_in_cart, :only => [:view_cart, :consent, :payment]

  def index
    #@location_id = params[:id]
    #@location = Location.find(@location_id)
    @fitnesscamps = FitnessCamp.future # can work in location
    #@locations = Location.where(_id: @location_id)
  end

  def all_fitness_camps
    @user = current_user || User.new
    if @user.member
      location = current_user.location ? current_user.location.name : "your location"
      flash[:notice] = "Our records show that you are a FitWit Member and your registration is accomplished automatically. Please see the lead trainer for #{location} if you have any questions."
      redirect_to :back
    else
      @fitness_camps = FitnessCamp.upcoming_and_current
      # if session cart is nil or session cart.items.empty?
      @cart_view = !(session[:cart].nil? || session[:cart].items.empty?)
    end
  end

  def cart
    @user = current_user
    if @user.member # they need to be blocked from registration
      redirect_to(:action => 'no_need_to_register')
    end
    # now we check to see if they are adding a subscription
    if params[:commit] == "Return to cart" # they submitted the consent form
      if params[:agree_to_terms] == "yes" # then we add a membership
        @cart.new_membership = true
      else # they didn't agree to the          # terms as needed
        flash[:notice] = "You must agree to the terms of this membership
                          by clicking on the consent form below before proceeding."
        redirect_to :action => :membership_info
      end
    end
    @existing_time_slots = @user.time_slots
    @vet_status = current_user.veteran_status
  end

  def add_to_cart
    # this processes the form when we add a camp to a cart
    unless current_user && current_user.member
      begin
        timeslot_id = params[:id]
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempt to access invalid product #{params[:id]}")
        flash[:notice] = "That product doesn't exist"
        redirect_to :back
      else
        @current_item = @cart.add_timeslot(timeslot_id)
        respond_to do |format|
          format.html { redirect_to :action => "all_fitness_camps" }
          format.js
        end
      end
    else
      @fitness_camps = FitnessCamp.upcoming_and_current
      location = current_user.location ? current_user.location.name : "your location"
      flash.now[:notice] = "Our records show that you are a FitWit Member and your registration is accomplished automatically. Please see the lead trainer for #{location} if you have any questions."
      render :all_fitness_camps
    end
  end

  def update_profile
    @user = current_user
  end

  def consent
    @user = current_user
    unless @user.update_attributes(params[:user])
      flash.now[:notice] = "Error updating your profile"
      render :update_profile
    else
      flash.now[:notice] = 'User information updated'
      @cart.consent_updated = false # still needed?
    end
  end

  def release_and_waiver_of_liability
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Health profile updated"
      render layout: "canvas" # do we really want a diff
    else
      flash.now[:notice] = "Error updating your health profile (see below)"
      render :consent
    end
  end

  def terms_of_participation
    #layout "canvas"
    unless session[:must_check_yes_on_terms] == true
      if params[:commit] == "Continue to Terms of Participation" # they submitted the consent form
        unless params[:agree_to_terms] == "yes" # then we add a membership
          session[:must_check] = true
          flash[:notice] = "Before proceeding, you must agree to the FitWit
                          Release and Waiver of Liability
                          by clicking on the form below."
          redirect_to :action => :release_and_waiver_of_liability
        else
          session[:must_check] = nil
          render layout: "canvas"
        end
      end # commit check
    end # check to see if we need another chance
  end

  def update_health_items
    # only checked items have an update matters
    u = current_user
    u.health_issues = []
    params[:user][:medical_condition_ids].each do |id|
      unless id.empty?
        h = HealthIssue.new
        m = MedicalCondition.find(id)
        h.medical_condition = m
        h.explanation = params[:user]["explanation_#{m.id}"]
        u.health_issues << h
      end
    end
    u.save!
    redirect_to fitness_camp_registration_consent_path
  end

  def payment
    # this creates an order out of a cart
    # block if payment_errors is empty and agree_to_terms isn't yes
    unless flash[:error] || params[:agree_to_terms] == "yes" # then we add a membership
      flash[:notice] = "Before proceeding, you must agree to the FitWit Terms of Participation by clicking on the form below."
      redirect_to :action => :terms_of_participation
    else
      @user = current_user
      @order_amount = @cart.total_price(@user)
      render layout: 'canvas'
    end
  end

  def pay
    @order = current_user.create_from_cart(@cart)
    # check to make sure credit card is valid
    unless @cart.new_membership
      # payment_errors of nil will go forward
      payment_errors = @order.complete_camp_purchase(params[:credit_card], current_user, @cart)
      if payment_errors.empty? || payment_errors == "[#]" || payment_errors == "#"
        redirect_to successful_registration_path(@order.id)
      else
        @user = current_user
        @order_amount = @cart.total_price(@user)
        flash[:error] = payment_errors
        render :payment, layout: 'canvas'
      end
    else
      "this feature is pending until they need the site to process memberships again"
    end
  end

  def empty_cart
    session[:cart] = nil
    flash[:notice] = "Your cart is now empty. You may start again by adding any of the camps below."
    redirect_to :action => "all_fitness_camps"
  end

  def registration_success
    # need successful registrations
    @registrations = Order.find(params[:order_id]).registrations
    @user = current_user
    (flash[:membership] == "true") ? @membership = true : @membership = nil
  end

  private

  def find_cart
    @cart = (session[:cart] ||= Cart.new)
  end

  # used as a before filter to ensure they have a cart to see some of these pages
  def ensure_items_in_cart
    unless @cart.total_items > 0 || @cart.new_membership
      flash[:notice] = "You need a non-empty cart to view this page"
      redirect_to :action => 'all_fitness_camps'
    end
  end

end
