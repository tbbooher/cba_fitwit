require 'ostruct'

class MyFitWitController < ApplicationController
  before_filter :get_user_id, :except => [:update_goal]
  # TODO Should I activate this again?	
  #ssl_required  :health_history

  def index
    @pagetitle = "My FitWit"
    @include_jquery = true
    @qtip = true
    # TODO
    # why are these all here anyway ?
    if @user_id
      @user = current_user # User.find(@user_id)
      @my_time_slots = @user.user_time_slots
      @my_fitness_camps = @my_time_slots.map { |ts| ts.fitness_camp } # ??
      @my_fit_wit_workouts = Workout.where(user: @user).all
    else
      flash[:notice] = "you need to be logged in"
      # redirect somewhere
    end
  end

  def profile
    @pagetitle = "Edit profile information"
    @user = current_user
    @include_jquery = true
    @qtip = true
    @fit_wit_form = true
    # TODO
    @names_of_titles_that_require_more_information = flash[:names_of_titles_that_require_more_information] || []
  end

  def upcoming_fitnesscamps
    @pagetitle = "Upcoming Fitness Camps"
    @mycamps = FitnessCamp.find_upcoming(@user_id)
  end

  def add_custom_workout
    @user = User.find(@user_id)
    @date = Date.parse(params[:date])
    @fit_wit_form = true
    @include_jquery = true
    #@fitwit_fit_wit_workout = true
    @admin = false
    @fit_wit_workout_list = Exercise.find(:all).map { |e| [e.name, e.id] }
    @custom_workout = CustomWorkout.new
    @action_url = 'input_custom_workout'

    respond_to do |format|
      format.html
      format.js
    end
  end

  def input_custom_workout
    cwo = params[:custom_workout]
    # sample submit
    if params[:adding_new_workout] == 'false'
      cwo[:custom_name] = "_a_fit_wit_workout_"
    else
      cwo[:fit_wit_workout_id] = 0
    end
    begin
      the_month = Date.parse(cwo[:workout_date]).strftime("%b-%Y")
    rescue
      flash[:notice] = "not a valid date"
      redirect_to :action => :fit_wit_workout_progress
    end
    @custom_workout = CustomWorkout.new(cwo)
    current_user.custom_workouts << @custom_workout

    respond_to do |format|
      if current_user.save
        flash[:notice] = 'Custom Workout was successfully created.'
        format.html { redirect_to :action => :fit_wit_workout_progress, :month => the_month }
        format.xml { render :xml => @custom_workout, :status => :created, :location => @custom_workout }
      else
        format.html { redirect_to :action => :add_custom_workout }
        format.xml { render :xml => @custom_workout.errors, :status => :unprocessable_entity }
      end
    end

  end

  def leader_board
    @fit_wit_workout_id = params[:id].to_f
    unless @fit_wit_workout_id == 0
      @fit_wit_workout = Exercise.find(@fit_wit_workout_id)
      @fit_wit_workout_title = @fit_wit_workout.name
      @exertions = Exertion.find_fit_wit_workout_progress(@user_id, @fit_wit_workout_id)
      @leaders = Exertion.find_by_sql("select * from prs where fit_wit_workout_id = #{@fit_wit_workout_id} order by common_value DESC limit 10;")
      user = User.find(@user_id)
      unless @fit_wit_workout.score_method.nil?
        @peers = @fit_wit_workout.find_peers(@exertions)
        @chart = get_progress_chart(user, @fit_wit_workout, @exertions)
      else
        @chart = nil
      end
    else
      @exertions = nil
    end
    # @fit_wit_workouts_select_list.delete_if{|e| e[1] == fit_wit_workout_id}
  end

  def get_progress_chart(user, fit_wit_workout, exertions)
    is_time = (fit_wit_workout.units == "seconds")
    gender = user.gender
    common_inputs = exertions.map { |e| e.common_value }
    common_vals = is_time ? common_inputs.delete_if { |e| e == 0 }.map { |cv| 1/cv } : common_inputs
    average = is_time ? 1/fit_wit_workout.find_average(gender) : fit_wit_workout.find_average(gender)
    best = is_time ? 1/fit_wit_workout.find_best(gender) : fit_wit_workout.find_best(gender)
    scale_factor = 80/([best] + [average] + common_vals).max # google charts have a max of 100
    scores = fit_wit_workout.score_method.nil? ? '' : common_vals.map { |c| c*scale_factor }
    dates = fit_wit_workout.score_method.nil? ? nil : exertions.map { |e| e.meeting.meeting_date }
    # build chart
    chart_width = 400
    progress_chart = GoogleChart.new()
    progress_chart.type = :line
    progress_chart.title = "#{user.full_name}'s progress for #{fit_wit_workout.name}"
    progress_chart.height = 200
    progress_chart.width = chart_width
    progress_chart.data = scores
    progress_chart.colors = '000000'
    progress_chart.show_labels = true
    progress_chart.labels = dates
    progress_chart.misc = "&chxt=x,r&chxl=1:|best|average&chxp=1,#{best*scale_factor},#{average*scale_factor}&chxs=1,0000dd,13,-1,t,FF0000&chxtc=1,-#{chart_width}"
    annotations = ''
    exertions.each_with_index do |e, index|
      score = e.score.gsub(",", "+").gsub("/", "+")
      annotations+="|A#{score},666666,0,#{index},15"
    end
    #        progress_chart.fills = 'B,cccccc,0,0,0|o,393939,0,-1,10.0' + annotations # filled, marker
    progress_chart.fills = 'o,393939,0,-1,10.0' + annotations # filled, marker
    return progress_chart.to_url
  end

  def fit_wit_workout_details
    @fit_wit_workout = Exercise.find(params[:id])
  end

#  def edit_my_info

  # end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    # TODO: any reason we need this?
    #params[:user][:role_ids] ||= []
    #    params[:user][:height] = get_inches_height(params[:my_height][:height_ft],
    #      params[:my_height][:height_in])
    @user = current_user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your profile was successfully updated.'
        format.html { redirect_to '/my_fit_wit/profile#tabs-1' }
        format.xml { head :ok }
      else
        flash[:notice] = 'Sorry, we have some errors.'
        format.html { redirect_to '/my_fit_wit/profile#tabs-1' }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def past_fitnesscamps
    @pagetitle = 'Past Fitness Camps'
    @mycamps = current_user.past_fitness_camps
  end

  def camp_fit_wit_workout_progress
    @pagetitle = 'Fitness Camp Report'
    @u = User.find(@user_id)
    @qtip = true
    @my_completed_fitnesscamps = current_user.past_fitness_camps.collect { |b| [b.title, b.id] }.uniq
    unless @my_completed_fitnesscamps.empty?
      if params[:fitnesscamp] and request.post?
        fitness_camp_id = params[:fitnesscamp][:fitness_camp_id].to_i
      else
        fitness_camp_id = @my_completed_fitnesscamps.first[1]
      end
      @myexertions = Exertion.find_for_user_and_fitness_camp(@user_id, fitness_camp_id)
      @my_fitness_camp = FitnessCamp.find(fitness_camp_id)
      @my_completed_fitnesscamps.delete_if { |bc_title, bc_id| bc_id == fitness_camp_id }
      @time_slot = @u.get_time_slot(@my_fitness_camp.id)
      unless @time_slot.nil?
        @meetings = @time_slot.meetings
        @meeting_count = @meetings.length
        @campers = @time_slot.campers
        @dates = get_months_and_years(@my_fitness_camp.session_start_date, @my_fitness_camp.session_end_date)
      end
    else
      # no fitnesscamps
    end
  end

  def my_goals
    @user = User.find(@user_id)
    @include_jquery = true
    @qtip = true
    @checkbox = true
    @pagetitle = "Manage Goals"
    goals = @user.goals
    @completed_goals = goals.find_all { |goal| goal if goal.completed? }
    @current_goals = goals-@completed_goals
    @new_goal = Goal.new
    @fit_wit_form = true
  end

  def add_goal

    begin
      the_date = Date.parse(params[:goal][:target_date])
      @goal = Goal.new(params[:goal])
      respond_to do |format|
        if @goal.save
          flash[:notice] = 'Goal was successfully created.'
          format.html { redirect_to :action => :my_goals }
          format.js
          format.xml { render :xml => @goal, :status => :created, :location => @goal }
        else
          format.html { render :action => :my_goals }
          format.xml { render :xml => @goal.errors, :status => :unprocessable_entity }
        end
      end
    rescue
      flash[:notice] = "please enter a target date in the correct format"
      redirect_to :action => :my_goals
    end
  end

  def delete_goal
    @goal = Goal.find(params[:id])
    @goal_id = @goal.id
    @message = "\"#{@goal.goal_name}\" has been deleted."
    Goal.destroy(@goal_id)
    respond_to do |format|
      format.html { redirect_to :action => 'my_goals' }
      format.js
    end
  end

  def update_goal
    @goal = Goal.find(params[:id])
    @message = "Congrats on completing your goal of \"#{@goal.goal_name}\"."
    @goal.completed = true
    @goal.completed_date = Date.today
    @goal.save!
    respond_to do |format|
      format.html { redirect_to :action => 'my_goals' }
      format.js
    end
  end

  def fit_wit_workout_progress
    # the main page for the different ways folks can see fit_wit_workout . . . by calendar, date, fit_wit_workout
    @include_jquery = true
    @qtip = true
    @fit_wit_form = true
    @pagetitle = "Fitness Progress"
    @user = current_user # User.find(@user_id)
    # for calendar
    @calendar_date = params[:month] ? Date.parse(params[:month]) : Date.today
    @date = Date.today # params[:date]) # we need to figure this out
    @fit_wit_workout_list = FitWitWorkout.all.map { |e| [e.name, e.id] }
    @calendar_events = get_calendar_events(@user)
    @custom_workout = @user.custom_workouts.new   # this is generated for the forms
    @custom_workout.score = ""
    @custom_workout.description = ""
    @action_url = 'input_custom_workout'
    # for single fit_wit_workout
    @fit_wit_workouts_select_list = @user.workouts.map { |e| [e.fit_wit_workout.name, e.fit_wit_workout.id] }.uniq
    @fit_wit_workouts_select_list << ['select a workout', 0]
    # prs
    @prs = @user.find_prs
    @fitness_camps = @user.past_fitness_camps.collect { |b| [b.title, b.session_start_date.strftime("%b-%Y")] }.uniq
    # measurements
    @my_measurements = @user.measurements
    @measurement = Measurement.new
  end

  def add_new_measurement
    @measurement = Measurement.new(params[:measurement])

    respond_to do |format|
      if @measurement.save
        flash[:notice] = 'Measurement was successfully created.'
        format.html { redirect_to "/my_fit_wit/fit_wit_workout_progress#tabs-4" }
        format.js
      else
        flash[:notice] = 'Errors.'
        render :action => :fit_wit_workout_progress
      end
    end
  end

  def load_calendar_date
    redirect_to :action => "fit_wit_workout_progress", :month=> params[:start_month]
  end

  def specific_fit_wit_workout
    @user = User.find(@user_id)
    @pagetitle = "Exercise history"
    @exertion = Exertion.find(params[:id])
    @fit_wit_workout = @exertion.fit_wit_workout
    @meeting = @exertion.meeting
    @include_jquery = true
    @qtip = true
    meeting_date = @meeting.meeting_date
    @the_date = meeting_date.strftime("%b #{meeting_date.day.ordinalize} %Y")
    @other_scores = find_previous_scores(@user.id, @fit_wit_workout.id, @fit_wit_workout.name, @exertion.id)
    # now what about other users at the same meeting
    #@other_folks_exertions = Exertion.all(:conditions => ["meetings.id = ?", @meeting.id], :joins => [{:meeting_user => :meeting}, :user], :order => "common_value DESC")
    @other_folks_exertions = Exertion.all(:select => "users.first_name, users.last_name, exertions.score, exertions.rxd",
                                          :conditions => ["meetings.id = ?", @meeting.id],
                                          :joins => [{:meeting_user => :meeting}, {:meeting_user => :user}],
                                          :order => "common_value DESC")

    #@other_folks_exertions = @exertion.meeting.exertions.select { |e| e.fit_wit_workout.id == @fit_wit_workout.id }.sort_by { |e| e.common_value }.reverse
    # and now what about all other folks that day

    @workouts_that_day = Exertion.all(:select => "users.first_name, users.last_name, exertions.score, exertions.rxd",
                                      :conditions => ["meetings.meeting_date = ? AND exertions.fit_wit_workout_id = ?", meeting_date, @fit_wit_workout.id],
                                      :joins => [{:meeting_user => :meeting}, {:meeting_user => :user}],
                                      :order => "common_value DESC")
    
    #@fit_wit_workout.exertions.select { |e| e.meeting.meeting_date == @exertion.meeting.meeting_date }.sort_by { |e| e.common_value }.reverse
    # leader board
    @leaders = @fit_wit_workout.find_leaders(@user.gender)
  end

  def process_fit_wit_history
    @user = User.find(@user_id)
    # @back_page = request.env["HTTP_REFERER"]
    if @user.update_attributes(params[:user])
      flash[:notice] = 'FitWit History Updated.'
      # TODO redirect to referring page
#      my_referrer = params[:referer] ? params[:referer] : {:controller => 'my_fit_wit', :action => 'profile'}
      redirect_to('/my_fit_wit/profile#tabs-3')
    else
      flash[:notice] = 'error'
      raise RuntimeError, "fit_wit_history update error"
    end
  end

  def health_history
    # just a process node at this point
    @user = User.find(@user_id) #needed
    # @back_page = request.env["HTTP_REFERER"]
    unless request.put?
      # needed still? maybe a raise here
    else
      # zero out all unchecked explanations
      user_params = zero_out_all_unchecked_explanations(params[:user])
      if @user.update_attributes(user_params)
        if names_of_titles_that_require_more_information = \
 user_has_not_explained_themself(params[:user]) #names_of_titles_that_require_more_information.empty?
          flash[:notice] = <<-END_OF_STRING
          You need to provide clarification for all
          health history items
          END_OF_STRING
          flash[:names_of_titles_that_require_more_information] = \
 names_of_titles_that_require_more_information
          redirect_to '/my_fit_wit/profile#tabs-2'
        else
          flash[:notice] = 'Health History Updated.'
          # TODO NEED TO GET THIS WORKING FROM REGISTRATION
          my_referrer = !session[:referrer].nil? ? \
 session[:referrer] : {:controller => 'my_fit_wit', :action => 'index'}
          redirect_to '/my_fit_wit/profile#tabs-2'
#          redirect_to(my_referrer)
        end # check for adequate information entered
      else # error
        flash[:notice] = 'FitWit history update error'
        redirect_to '/my_fit_wit/profile#tabs-2'
        #raise RuntimeError, "fit_wit_history update error"
      end #user attribute update check
    end # form submission check
  end

  def change_password
    @pagetitle = 'Change password'
    @user = current_user
    @fit_wit_form = true
    if request.put?
      if User.authenticate(@user.user_name, params[:current_password])
        if @user.update_attributes(params[:user])
          flash[:notice] = 'update successful'
          redirect_to '/my_fit_wit/profile#tabs-4'
        else
          flash[:notice] = 'passwords did not match'
          redirect_to '/my_fit_wit/profile#tabs-4'
        end
      else
        flash[:notice] = 'incorrect initial password'
        redirect_to '/my_fit_wit/profile#tabs-4'
      end
    else # just a normal form
    end
  end

  private

  def get_calendar_events(user)
    fit_wit_workouts = user.workouts.map { |e| OpenStruct.new(:exertion_id => e.id,
                                                               :meeting_date => e.meeting.meeting_date,
                                                               :score => e.score,
                                                               :name => e.fit_wit_workout.name,
                                                               :format_class => 'fit_wit_workout',
                                                               :previous_scores => "<b>Score:</b> " + cw.score + "<br />" + find_previous_scores(@user.id, cw.fit_wit_workout.id, cw.fit_wit_workout.name, cw.id)) }

    custom_workouts = user.custom_workouts.map { |cw| OpenStruct.new(:exertion_id => cw.fit_wit_workout_id,
                                                                    :meeting_date => cw.workout_date,
                                                                    :score => cw.score,
                                                                    :name => cw.title,
                                                                    :format_class => 'custom_workout',
                                                                    :previous_scores => "<b>Score:</b> " + cw.score + "<br />" + cw.description) }

    goals = user.goals.map { |g| OpenStruct.new(:exertion_id => g.id,
                                                :meeting_date => g.target_date,
                                                :score => '',
                                                :name => "Goal: " + g.goal_name,
                                                :format_class => 'goal',
                                                :previous_scores => g.description.empty? ? "no description" : g.description) }

    return fit_wit_workouts + custom_workouts + goals
  end


  def list_fit_wit_workout(e)
    "#{e.name} on #{e.date_accomplished}"
  end

  def find_previous_scores(user_id, fit_wit_workout_id, fit_wit_workout_name, exertion_id)
    prev_exertions = Exertion.find_fit_wit_workout_progress(user_id, fit_wit_workout_id).delete_if { |ex| ex.id == exertion_id }
    unless prev_exertions.empty?
      prev_scores = "<p><b>Previous Scores:</b></p><table style='width:100%'>\n"
      odd = true
      myear_old = ""
      prev_exertions.each do |e|
        color = odd ? 'light' :'dark'
        odd = !odd
        mdate = e.meeting.meeting_date
        myear = mdate.year
        if myear != myear_old
          myear_old = myear
          prev_scores += "<tr class='#{color}'><td><b>#{myear.to_s}</b></td><td>&nbsp;</td></tr>\n"
        end
        prev_scores += "<tr class='#{color}'><td>#{mdate.strftime('%d-%b')}</td><td>#{e.score}</td></tr>\n"
      end
      prev_scores += "</table>\n"
    else
      prev_scores = "No previous #{fit_wit_workout_name} workouts\n"
    end
    return prev_scores
  end

  def zero_out_all_unchecked_explanations(user_params)
    condition_params = user_params.reject { |key, value| \
 key =~ /_explanation$/ || \
 value == "true" || \
 key == "fitness_level" }
    condition_params.each do |key, value| # for each false condition set the params equal to ""
      explanation_name = "#{key}_explanation".to_sym
      user_params[explanation_name] = "" if user_params[explanation_name]
    end
    return user_params
  end

  def user_has_not_explained_themself(user_params)
    #condition_params = params.keys.map{|k| k.to_s}.grep(/[^(_explanation)]$/)
    condition_params = user_params.reject { |key, value| key =~ /_explanation$/ || \
 value == "false" || key == 'fitness_level' }
    names_of_titles_that_require_more_information = [] # initialize

    condition_params.each do |key, value|
      field_content = user_params["#{key}_explanation".to_sym]
      if field_content =~ /^\s*$/ || field_content == "Please enter an explanation"
        names_of_titles_that_require_more_information << key
      end
    end

    if names_of_titles_that_require_more_information.empty?
      return nil
    else
      return names_of_titles_that_require_more_information
    end

  end

  private

  def get_inches_height(my_feet, my_inches)
    ((my_feet.to_i*12) + my_inches.to_i)
  end

  def get_months_and_years(st, ed)
    yr_month_array = []
    date = st
    while date.month <= ed.month do
      yr_month_array << [date.month, date.year]
      date = date.next_month
    end
    yr_month_array
  end

  def get_months_and_years(st, ed)
    m = []
    d = st.beginning_of_month
    while d <= ed.beginning_of_month
      m << [d.month, d.year]
      d = d.next_month
    end
    return m
  end

  def get_user_id
    @user_id = current_user.id
    @my_fit_wit = true
  end

end
