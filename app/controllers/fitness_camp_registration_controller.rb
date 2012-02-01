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
    @fitness_camps = FitnessCamp.upcoming_and_current
    # if session cart is nil or session cart.items.empty?
    @cart_view = !(session[:cart].nil? || session[:cart].items.empty?)
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
    #delete_existing_camps_from_cart(@cart)
    # @cart_view = !session[:cart].nil?
    render layout: "canvas"
  end

  def add_to_cart
    # this processes the form when we add a camp to a cart
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
  end

  def release_and_waiver_of_liability
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
    #u.save!
    #flash[:notice] = "Health History Updated"
    # some check to make sure we have the right data
    # save the user data
    # should we update the user with a notice that they have updated health history 
    unless @cart.consent_updated
      pa = params[:has_physician_approval]
      pa_exp = params[:has_physician_approval_explanation]
      ma = params[:meds_affect_vital_signs]
      ma_exp = params[:meds_affect_vital_signs_explanation]
      if ((pa_exp.empty? && !pa) || (ma_exp.empty? && ma))
        flash[:notice] = 'You must explain'
        flash[:checked_values] = params[:health_approval]
        redirect_to :action => 'consent'
      else
        u = current_user
        u.fitness_level = params[:fitness_level]
        u.has_physician_approval = pa
        u.has_physician_approval_explanation = pa_exp
        u.meds_affect_vital_signs = ma
        u.meds_affect_vital_signs_explanation = ma_exp
        u.save!
        @cart.consent_updated = true
        # we need to think about how we save this . . .
      end
      render layout: "canvas" # do we really want a diff
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
        end
      end # commit check
    end # check to see if we need another chance
    render layout: "canvas"
  end

  def update_profile
    @user = current_user
  end

  def consent
    @user = current_user
    unless @user.update_attributes(params[:user])
      redirect_to :back, notice: "Error updating your user account"
    else
      flash[:notice] = 'User information updated'
      @cart.consent_updated = false
    end
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
    # here the user enters credit card information
    # after data are entered, the user calls the method 'pay'
    #@health_approval = session[:health_approval]
    #@health_approval.delete_if {|key, value| key =~ /_explanation$/ && value == "Please explain"}
    @user = current_user
    @order_amount = @cart.total_price(@user)
    @cc_errors = flash[:cc_errors] if flash[:cc_errors]
    render layout: 'canvas'
    #@membership = @cart.new_membership
  end

  def really_pay
    @order = Order.find(params[:id])
    # check to make sure credit card is valid
    unless @cart.new_membership
      if @order.complete_camp_purchase(params[:credit_card], current_user)
        render action: "success"
      else
        render action: "failure"
      end
    else
      "We need to write up membership purchase "
    end
  end

  def save_order
    # this creates an order out of a cart
    unless params[:agree_to_terms] == "yes" # then we add a membership
                                            # session[:must_check_yes_on_terms] = true
      flash[:notice] = "Before proceeding, you must agree to the FitWit Terms of Participation by clicking on the form below."
      redirect_to :action => :terms_of_participation
    else
      o = current_user.create_from_cart(@cart)
      if o.save!
        redirect_to :action => :payment, :id => o.id
      else # something went wrong
        flash[:notice] = "Error saving order"
        redirect_to :action => :terms_of_participation
      end # save error check
    end # agree to term check
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

  def ensure_items_in_cart
    unless @cart.total_items > 0 || @cart.new_membership
      flash[:notice] = "You need a non-empty cart to view this page"
      redirect_to :action => 'all_fitness_camps'
    end
  end

end
