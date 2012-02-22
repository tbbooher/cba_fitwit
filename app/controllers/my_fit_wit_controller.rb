require 'ostruct'

class MyFitWitController < ApplicationController
  before_filter :get_user
  #ssl_required  :health_history

  def index
    @pagetitle = "My FitWit"
    @include_jquery = true
    @qtip = true
    if @user
      @my_time_slots = @user.user_time_slots
      @my_fitness_camps = @my_time_slots.map { |ts| ts.fitness_camp } if @my_time_slots
      @my_fit_wit_workouts = Workout.where(user: @user).all
    else
      flash[:notice] = "you need to be logged in"
      redirect_to root_path
    end
  end

  def upcoming_fitnesscamps
    @pagetitle = "Upcoming Fitness Camps"
    @mycamps = FitnessCamp.find_upcoming(@user.id)
  end

  def add_custom_workout
    @date = Date.parse(params[:date])
    @fit_wit_form = true
    @include_jquery = true
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
      cwo[:is_a_fit_wit_workout] = true
    else
      cwo[:fit_wit_workout_id] = 0
      cwo[:is_a_fit_wit_workout] = false # this is the default
    end
    begin
      the_month = Date.parse(cwo[:workout_date]).strftime("%b-%Y")
    rescue
      flash[:notice] = "not a valid date"
      redirect_to :action => :fit_wit_workout_progress
    end
    @custom_workout = CustomWorkout.new(cwo)
    u = current_user
    u.custom_workouts.push(@custom_workout)

    respond_to do |format|
      if u.save!
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
    @fit_wit_workout_id = params[:id]
    user = current_user
    unless @fit_wit_workout_id == 0
      @fit_wit_workout = FitWitWorkout.find(@fit_wit_workout_id)
      @fit_wit_workout_title = @fit_wit_workout.name
      @workouts = Workout.for_user(user).for_fww(@fit_wit_workout)
      @leaders = @fit_wit_workout.top_10_all_fit_wit_by_gender(user.sex_symbol)
          #find_by_sql("select * from prs where fit_wit_workout_id = #{@fit_wit_workout_id} order by common_value DESC limit 10;")
      unless @fit_wit_workout.score_method.nil?
        @peers = @fit_wit_workout.find_competition(user)
        @chart = @fit_wit_workout.get_progress_chart(user, @workouts)
      else
        @chart = nil
      end
    else
      @workouts = nil
    end
    # @fit_wit_workouts_select_list.delete_if{|e| e[1] == fit_wit_workout_id}
  end

  def past_fitnesscamps
    @pagetitle = 'Past Fitness Camps'
    @mycamps = current_user.past_fitness_camps
  end

  def camp_fit_wit_workout_progress
    @pagetitle = 'Fitness Camp Report'
    @qtip = true
    if current_user.past_fitness_camps
      @my_completed_fitnesscamps = current_user.past_fitness_camps.collect { |b| [b.title, b.id] }.uniq
    end
    if @my_completed_fitnesscamps
      if params[:fitnesscamp] and request.post?
        fitness_camp_id = params[:fitnesscamp][:fitness_camp_id].to_i
      else
        fitness_camp_id = @my_completed_fitnesscamps.first[1]
      end
      @myworkouts = Workout.find_for_user_and_fitness_camp(@user.id, fitness_camp_id)
      @my_fitness_camp = FitnessCamp.find(fitness_camp_id)
      @my_completed_fitnesscamps.delete_if { |bc_title, bc_id| bc_id == fitness_camp_id }
      @time_slot = @user.get_time_slot(@my_fitness_camp.id)
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
      g = Goal.new
      g.goal_name = params[:goal][:goal_name]
      g.description = params[:goal][:description]
      g.date_added = Date.parse(params[:goal][:date_added])
      g.target_date = Date.parse(params[:goal][:target_date])
      g.completed = false
      @user.goals << g
      respond_to do |format|
        if @user.save
          flash[:notice] = 'Goal was successfully created.'
          format.html { redirect_to :action => :my_goals }
          format.js
          format.xml { render :xml => g, :status => :created, :location => g }
        else
          format.html { render :action => :my_goals }
          format.xml { render :xml => g.errors, :status => :unprocessable_entity }
        end
      end
    rescue
      flash[:notice] = "please enter a target date in the correct format"
      redirect_to :action => :my_goals
    end
  end

  def delete_goal
    @goal = @user.goals.find(params[:goal_id])
    @message = "Your goal: \"#{@goal.goal_name}\" has been deleted."
    @user.goals.find(params[:goal_id]).destroy
    respond_to do |format|
      format.html { redirect_to :action => 'my_goals' }
      format.js
    end
  end

  def update_goal
    @goal = @user.goals.find(params[:goal_id])
    @message = "Congrats on completing your goal of \"#{@goal.goal_name}\"."
    @goal.completed = true
    @goal.completed_date = Date.today
    @user.save!
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
    @fit_wit_workouts_select_list = @user.workouts.map { |e| [e.fit_wit_workout.name, e.fit_wit_workout_id] }.uniq
    @fit_wit_workouts_select_list << ['select a workout', 0]
    # prs
    @prs = @user.find_prs
    if @user.past_fitness_camps
      @fitness_camps = @user.past_fitness_camps.collect { |b| [b.title, b.session_start_date.strftime("%b-%Y")] }.uniq
    end
    # measurements
    @my_measurements = @user.measurements
    @measurement = Measurement.new
  end

  def add_new_measurement
    m = Measurement.new
    m.review_date = Date.parse(params[:measurement][:review_date])
    m.height = params[:measurement][:height]
    m.weight = params[:measurement][:weight]
    m.chest = params[:measurement][:chest]
    m.waist = params[:measurement][:waist]
    m.hip = params[:measurement][:hip]
    m.right_arm = params[:measurement][:right_arm]
    m.right_thigh = params[:measurement][:right_thigh]
    m.bmi = params[:measurement][:bmi]
    m.bodyfat_percentage = params[:measurement][:bodyfat_percentage]
    @user.measurements << m
    respond_to do |format|
      if @user.save
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
    @pagetitle = "Exercise history"
    @workout = Workout.find(params[:id])
    @fit_wit_workout = @workout.fit_wit_workout
    @meeting = @workout.meeting
    @include_jquery = true
    @qtip = true
    meeting_date = @meeting.meeting_date
    @the_date = meeting_date.strftime("%b #{meeting_date.day.ordinalize} %Y")
    @other_scores = find_previous_scores(@user, @fit_wit_workout, @fit_wit_workout.name, @workout.id)
    # now what about other users at the same meetings
    #@other_folks_workouts = Workout.all(:conditions => ["meetings.id = ?", @meetings.id], :joins => [{:meeting_user => :meetings}, :user], :order => "common_value DESC")
    @other_folks_workouts = Workout.all(:select => "users.first_name, users.last_name, workouts.score, workouts.rxd",
                                          :conditions => ["meetings.id = ?", @meeting.id],
                                          :joins => [{:meeting_user => :meetings}, {:meeting_user => :user}],
                                          :order => "common_value DESC")

    #@other_folks_workouts = @workout.meetings.workouts.select { |e| e.fit_wit_workout.id == @fit_wit_workout.id }.sort_by { |e| e.common_value }.reverse
    # and now what about all other folks that day

    @workouts_that_day = Workout.all(:select => "users.first_name, users.last_name, workouts.score, workouts.rxd",
                                      :conditions => ["meetings.meeting_date = ? AND workouts.fit_wit_workout_id = ?", meeting_date, @fit_wit_workout.id],
                                      :joins => [{:meeting_user => :meetings}, {:meeting_user => :user}],
                                      :order => "common_value DESC")
    
    #@fit_wit_workout.workouts.select { |e| e.meetings.meeting_date == @workout.meetings.meeting_date }.sort_by { |e| e.common_value }.reverse
    # leader board
    @leaders = @fit_wit_workout.find_leaders(@user.gender)
  end

  private

  def get_calendar_events(user)
    fit_wit_workouts = user.workouts.map { |w| OpenStruct.new(:exertion_id => w.id,
                                                               :meeting_date => w.meeting.meeting_date,
                                                               :score => w.score,
                                                               :name => w.fit_wit_workout.name,
                                                               :format_class => 'fit_wit_workout',
                                                               :previous_scores => "<b>Score:</b> " + w.score + "<br />" + find_previous_scores(@user, w.fit_wit_workout, w.fit_wit_workout.name, w.id)) }

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

  def find_previous_scores(user, fit_wit_workout, fit_wit_workout_name, workout_id)
    prev_workouts = Workout.for_user(user).for_fww(fit_wit_workout).all.to_a.delete_if { |w| w.id == workout_id }
    unless prev_workouts.empty?
      prev_scores = "<p><b>Previous Scores:</b></p><table style='width:100%'>\n"
      odd = true
      myear_old = ""
      prev_workouts.each do |e|
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

  #def get_months_and_years(st, ed)
  #  yr_month_array = []
  #  date = st
  #  while date.month <= ed.month do
  #    yr_month_array << [date.month, date.year]
  #    date = date.next_month
  #  end
  #  yr_month_array
  #end

  def get_months_and_years(st, ed)
    m = []
    d = st.beginning_of_month
    while d <= ed.beginning_of_month
      m << [d.month, d.year]
      d = d.next_month
    end
    return m
  end

  def get_user
    authorize! :manage, User, message: "You need to be logged to access MyFitWit"
    @user = current_user
    @my_fit_wit = true
  end

end
