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
    if @user.has_active_subscription # they need to be blocked from registration
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
    delete_existing_camps_from_cart(@cart)
    # @cart_view = !session[:cart].nil?
    render layout: "canvas"
  end

  def medical_conditions
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
    flash[:notice] = "Health History Updated"
    redirect_to fitness_camp_registration_consent_path
  end

  def add_to_cart
    # this processes the form when we add a camp to a cart
    begin
      timeslot_id = params[:id]
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}")
      redirect_to_index("Invalid Product")
    else
      @current_item = @cart.add_timeslot(timeslot_id)
      respond_to do |format|
        format.html { redirect_to :action => "all_fitness_camps" }
        format.js
      end
    end
  end

  #def no_need_to_register
  #  @pagetitle = "You are a member, there is no need to register"
  #end

  def release_and_waiver_of_liability
    # some check to make sure we have the right data
    # save the user data
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
      render layout: "canvas"
    end

    ## load the next page
    ##int_gender = current_user.gender
    #unless session[:must_check] == true # this just ensures that we are not rejected by the next page
    #  if not_assigned?(int_gender, params[:health_approval]) # then they
    #    # need to check some boxes
    #    #flash[:from_save_order] = "true" # TODO is this still needed
    #  else # they need to make sure they have fully entered the data
    #    if button_hash = user_has_issues?(params[:health_approval]) # !issue_array.map{|title,value,content| value}.all? # only let 'em by if all required fields are non-empty
    #      flash[:notice] = "Please provide clarification for the questions marked below."
    #      flash[:checked_values] = params[:health_approval]
    #      flash[:button_hash] = button_hash
    #      redirect_to :action => 'consent'
    #    else # we can go forward, save the user information in the session
    #      session[:health_approval] = params[:health_approval]
    #    end # issue check
    #  end # big if
    #end # check referral
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

  def consent
    @cart.consent_updated = false
    # the purpose of the consent view is to let the user view their
    # health history then they can go on to the payment view
    # testing
    # if form element agree_to_terms is not 'yes' then we must
    # redirect back to membership_info
    @user = current_user
    # which path do we want to go down, membership or payment
    @checked_values = flash[:checked_values] || []
    @button_hash = flash[:button_hash] || {}
    session[:referrer] = {:controller => :registration, :action => "consent"}
    @membership = @cart.new_membership # this need to be here ??
    # for health consent form
    @names_of_titles_that_require_more_information = flash[:names_of_titles_that_require_more_information] || []
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
    if @order.complete_purchase(params[:credit_card], current_user)
      render action: "success"
    else
      render action: "failure"
    end
  end

  def pay
    # this method gets the whole registration process going
    # this method is currently way too long and desperately needs refactoring
    @order = Order.find(params[:id])
    @credit_card = ActiveMerchant::Billing::CreditCard.new(params[:credit_card])
    is_membership = @cart.new_membership
    if @credit_card.valid? #=> auto-detects the card type
      @user = current_user
      options = build_options(@user, params[:billing_address][:us_state],
        params[:billing_address][:zip],
        params[:billing_address][:city],
        params[:billing_address][:address1],
        params[:billing_address][:address2])
      if is_membership
        subscription = @order.create_subscription(@credit_card, options)
        is_success = subscription.success?
      else
        purchase = @order.authorize_payment(@credit_card, options)
        is_success = purchase.success?
      end
      if is_success
        send_emails(is_membership,@user,@order,@cart)
        update_user_information(@user, params)
        # time to register the user for the class
        @order.register_timeslots_from_cart(@cart)
        session[:cart] = nil
        session[:health_approval] = nil
        unless is_membership
          capture = @order.capture_payment
          if capture.success?
            flash[:membership] = "false"
            redirect_to :action => :registration_success, :id => @order.id
          else
            flash[:notice] = 'capture failed'
            redirect_to :action => :payment, :id => @order.id # not :back
          end
        else
          # we need to let the world know that a user has a membership
          @user.has_active_subscription = true
          @user.save
          flash[:membership] = "true"
          redirect_to :action => :registration_success, :id => @order.id
        end # membership check
      else
        #if purchase.params['missingField'].nil?
        flash[:notice] = "!! " + purchase.message + "<br />"  +
          purchase.params['missingField'].to_s
        #flash[:notice] = ": " + purchase.errors.full_messages.join(', ')
        redirect_to :action => :payment, :id => @order.id
      end
    else
      flash[:cc_errors] = @credit_card.errors.full_messages   #build_cc_errors(@credit_card.errors)

      redirect_to :action => :payment, :id => @order.id
    end
  end

  def save_order
    # this creates an order out of a cart
    usr_id = current_user.id
    #if params[:commit] == "Proceed to Payment" # they submitted the consent form
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
    #end # commit check
  end # def

  def empty_cart
    #@include_javascript = true
    #@location_id = params[:id]
    session[:cart] = nil
    #redirect_to_index(nil,params[:id])
    flash[:notice] = "Your cart is now empty. You may start again by adding any of the camps below."
    #unless @location_id
      redirect_to :action => "all_fitness_camps"
    #else
    #  redirect_to :action => "index", :id => @location_id
    #end
  end

  def registration_success
    @pagetitle = 'Successful Registration'
    # need successful registrations
    @registrations = Order.find(params[:id]).registrations
    @user = current_user
    (flash[:membership] == "true") ? @membership = true : @membership = nil
  end

  private

  #def zero_out_all_unchecked_explanations(user_params)
  #  condition_params = user_params.reject {|key, value| \
  #      key =~ /_explanation$/ || \
  #      value == "true" || \
  #      key == "fitness_level" }
  #  condition_params.each do |key, value|  # for each false condition set the params equal to ""
  #    explanation_name = "#{key}_explanation".to_sym
  #    user_params[explanation_name] = "" if user_params[explanation_name]
  #  end
  #  return user_params
  #end
  #
  #def user_has_not_explained_themself(user_params)
  #  #condition_params = params.keys.map{|k| k.to_s}.grep(/[^(_explanation)]$/)
  #  condition_params = user_params.reject {|key, value| key =~ /_explanation$/ || \
  #      value == "false" || key == 'fitness_level'}
  #  names_of_titles_that_require_more_information = [] # initialize
  #
  #  condition_params.each do |key, value|
  #    field_content = user_params["#{key}_explanation".to_sym]
  #    if field_content =~ /^\s*$/ || field_content == "Please enter an explanation"
  #      names_of_titles_that_require_more_information << key
  #    end
  #  end
  #
  #  if names_of_titles_that_require_more_information.empty?
  #    return nil
  #  else
  #    return names_of_titles_that_require_more_information
  #  end
  #
  #end

#  def build_desc(health_approval_hash)
#    # this builds the description for the user's order
#    out = ""
#    health_approval_hash.each do |method, value|
#      if method =~ /_explanation$/
#        out += "#{method.humanize} is \"#{value}\"\n"
#      end
#    end
#    unless out.empty?
#      return out
#    else
#      return "No participation issues noted"
#    end
#  end
#
#  def user_has_issues?(health_hash)
#    # assume no issue
#    # 1 => matters for both (gender 1 or 2)
#    # 2 => matters just for women (gender = 2)
##     issues = [['participation_approved','No',0],
##               ['taking_medications','Yes',0],
##               ['post_menopausal_female','N/A',1],
##               ['taking_estrogen','N/A',1]]
#    field_info = {:participation_approved => 'No',
#                  :taking_medications => 'Yes'}
#    button_hash = {}
#    more_info_needed = false
#    field_info.each do |title, yes_value|
#      button_hash.merge!(title => {})
#      if (health_hash[title] == yes_value)
#        explanation_content = health_hash["#{title}_explanation"] || "Please explain"
#        unless explanation_content.empty? ||
#            explanation_content =~ /^\s*$/ ||
#            explanation_content == "Please explain"
#           button_hash[title].merge!(:explanation_sufficient => true)
#        else
#          more_info_needed = true
#        end
#        button_hash[title].merge!(:tag_content => explanation_content)
#      end
#    end # each
#    # if button_hash[title] is not empty, then put button hash
#    # forward, otherwise return nil (false)
#    return more_info_needed && button_hash
#  end



  def update_user_information(user, params)
    info_hash = { }
    user.first_name = params[:billing_address][:first_name] unless params[:billing_address][:first_name].blank?
    user.last_name =  params[:billing_address][:last_name] unless params[:billing_address][:last_name].blank?
    user.email_address = params[:billing_address][:email_address] unless params[:billing_address][:email_address].blank?
    user.street_address1 =  params[:billing_address][:street_address1] unless params[:billing_address][:street_address1].blank?
    user.street_address2 =  params[:billing_address][:street_address2] unless params[:billing_address][:street_address2].blank?
    user.city =  params[:billing_address][:city] unless params[:billing_address][:city].blank?
    user.us_state = params[:billing_address][:us_state] unless params[:billing_address][:us_state].blank?
    user.zip = params[:billing_address][:zip] unless params[:billing_address][:zip].blank?
    if user.save! && info_hash.size > 0
      flash[:notice] = "Updated user information"
    end
  end

  def redirect_to_index(msg = nil, my_id = nil)
    flash[:notice] = msg if msg
    if my_id.nil?
      redirect_to :action => :index
    else
      redirect_to :action => :index, :id => my_id
    end
  end

  def find_cart
    @cart = (session[:cart] ||= Cart.new)
  end

  def ensure_items_in_cart
    unless @cart.total_items > 0 || @cart.new_membership
      flash[:notice] = "you need a non-empty cart to view this page"
      redirect_to :action => 'all_fitness_camps'
    end
  end

  #def not_assigned?(int_gender, health_hash)
  #  out = false
  #  if health_hash.nil?
  #    out = true
  #  else
  #    out = health_hash[:participation_approved].nil? || out
  #    out = health_hash[:taking_medications].nil? || out
  #    if int_gender == :female
  #      out = health_hash[:post_menopausal_female].nil? || out
  #      out = health_hash[:taking_estrogen].nil? || out
  #    end
  #  end
  #  out
  #end


  #
  #def delete_existing_camps_from_cart(cart)
  #  # this should be completely deprecated
  #  deleted = nil  # bool to let us know if we had to delete a class
  #  del_items = '' # since the user had already registered for it
  #  # should really make a subroutine for this -- just check to see if
  #  # there is a class in the cart that the user is already registered for
  #  # TODO tbb 0812 -- this really needs refactored
  #  cart.items.each do |ci|
  #    if @existing_time_slots.include?(ci.time_slot)
  #      del_items += "#{ci.timeslot.short_title}<br />"
  #      cart.items.delete(ci)
  #      deleted = true
  #    end
  #  end
  #  if deleted
  #    flash[:notice] = "You have previously registered for:<br />#{del_items}" +
  #      " We have removed any existing registrations from your cart." +
  #      " Please continue."
  #    redirect_to :back
  #  end
  #end

end
