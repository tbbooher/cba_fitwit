

class MyFitWitController < ApplicationController
  before_filter :get_user

  def index
    if @user
      @my_time_slots = @user.user_time_slots
      @my_fitness_camps = @my_time_slots.map { |ts| ts.fitness_camp } if @my_time_slots
      @my_fit_wit_workouts = Workout.where(user: @user).all
    else
      flash[:notice] = "you need to be logged in"
      redirect_to root_path
    end
  end

  def add_custom_workout
    @date = Date.parse(params[:date])
    @fit_wit_workout_list = FitWitWorkout.all # .map { |e| [e.name, e.id] }
    @custom_workout = @user.custom_workouts.new   # this is generated for the forms
  end

  def show_custom_workout
    @custom_workout = @user.custom_workouts.find(params[:id])
    @date = @custom_workout.workout_date
    @fit_wit_workout_list = FitWitWorkout.all # .map { |e| [e.name, e.id] }
    render :add_custom_workout
  end

  def upcoming_fitnesscamps
    @mycamps = FitnessCamp.find_upcoming(@user.id)
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
    @mycamps = current_user.past_fitness_camps
  end

  def camp_fit_wit_workout_progress
    if current_user.past_fitness_camps
      @my_completed_fitnesscamps = current_user.past_fitness_camps.collect { |b| [b.title, b.id] }.uniq
    end
    unless current_user.past_fitness_camps.empty?
      if params[:fitnesscamp] and request.post?
        fitness_camp_id = params[:fitnesscamp][:fitness_camp_id].to_i
      else
        fitness_camp_id = @my_completed_fitnesscamps.first
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
    # for calendar
    @calendar_date = params[:month] ? Date.parse(params[:month]) : Date.today
    @date = Date.today # params[:date]) # we need to figure this out
    @calendar_events = @user.get_calendar_events

    # for single fit_wit_workout
    @fit_wit_workouts_select_list = @user.workouts.map { |e| [e.fit_wit_workout.name, e.fit_wit_workout_id] }.uniq
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
    @workout = Workout.find(params[:id])
    @fit_wit_workout = @workout.fit_wit_workout
    @meeting = @workout.meeting
    meeting_date = @meeting.meeting_date
    @the_date = meeting_date.strftime("%b #{meeting_date.day.ordinalize} %Y")
    @other_scores = find_previous_scores(@user, @fit_wit_workout, @fit_wit_workout.name, @workout.id)
    # now what about other users at the same meetings
    #@other_folks_workouts = Workout.all(:conditions => ["meetings.id = ?", @meetings.id], :joins => [{:meeting_user => :meetings}, :user], :order => "common_value DESC")
    # MONGOID ! ! !
    @other_folks_workouts = Workout.all(:select => "users.first_name, users.last_name, workouts.score, workouts.rxd",
                                          :conditions => ["meetings.id = ?", @meeting.id],
                                          :joins => [{:meeting_user => :meetings}, {:meeting_user => :user}],
                                          :order => "common_value DESC")

    #@other_folks_workouts = @workout.meetings.workouts.select { |e| e.fit_wit_workout.id == @fit_wit_workout.id }.sort_by { |e| e.common_value }.reverse
    # and now what about all other folks that day
    # MONGOID ! ! !
    @workouts_that_day = Workout.all(:select => "users.first_name, users.last_name, workouts.score, workouts.rxd",
                                      :conditions => ["meetings.meeting_date = ? AND workouts.fit_wit_workout_id = ?", meeting_date, @fit_wit_workout.id],
                                      :joins => [{:meeting_user => :meetings}, {:meeting_user => :user}],
                                      :order => "common_value DESC")
    
    #@fit_wit_workout.workouts.select { |e| e.meetings.meeting_date == @workout.meetings.meeting_date }.sort_by { |e| e.common_value }.reverse
    # leader board
    @leaders = @fit_wit_workout.find_leaders(@user.gender)
  end

  private
  # TODO -- all this needs to be moved to the model layer

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
  end

end
