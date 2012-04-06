class Backend::WorkoutTrackerController < Backend::ApplicationController

  # this whole controller might be un-necessary -- we should treat 
  # workouts as a nested attribute of meeting

  def add_workout_for_user
    @user = User.find(params[:user_id])
    @meeting = Meeting.find(params[:meeting_id])
    @users_workouts = @meeting.workouts.where(user_id: @user.id).all.to_a
    #@exertions = Exertion.find(:all,:conditions => ['meeting_user_id = ?',@meeting_user_id])
    @other_attendees = @meeting.attendees.to_a - @user.to_a
    @workout = Workout.new
  end

  def coach_enters_scores
    @meeting = Meeting.find(params[:meeting_id])
    @time_slot = @meeting.time_slot
    @fitness_camp = @time_slot.fitness_camp
    @location = @fitness_camp.location
    @new_workouts = []
    @meeting.attendees.asc(:first_name).each do |user|
      @new_workouts << @meeting.workouts.build(user_id: user.id)
    end
    @possible_workouts = [["You must select a workout", 0]] +  FitWitWorkout.alphabetical.map{|fww| [fww.name, fww.id]}
  end

  def update_workout_for_user
    # action_method
    @workout = Workout.new(params[:workout])
    @meeting = Meeting.find(params[:workout][:meeting_id])
    if @workout.save
      ts = @meeting.time_slot
      fc = ts.fitness_camp
      l = fc.location.id
      flash[:success] = "Successfully created workout."
      redirect_to backend_location_fitness_camp_time_slot_meeting_path(l, fc.id, ts.id, @meeting.id)
    else
      flash.now[:error] = "Error adding workout."
      @user = User.find(params[:workout][:user_id])
      @other_attendees = @meeting.attendees.to_a - @user.to_a
      @users_workouts = @meeting.workouts.where(user_id: @user.id).all.to_a
      render action: :add_workout_for_user
    end
  end

  def update_workouts_for_camp
    @meeting = Meeting.find(params[:id])
    ts = @meeting.time_slot
    fc = ts.fitness_camp
    l = fc.location.id
    if @meeting.update_attributes(params[:meeting])
      flash[:success] = "Successfully recorded all workouts"
      redirect_to  backend_location_fitness_camp_time_slot_meeting_path(l,fc.id,ts.id,@meeting.id)
    else
      # we can use this to auto-select the workout they selected
      # probably should, but worried about jquery stuff
      #@fit_wit_workout_id = params[:fit_wit_workout_id]
      flash.now[:error] = "Error saving workout"
      @new_workouts = @meeting.workouts.select {|w| !w.persisted?}
      @possible_workouts = [["You must select a workout", 0]] +  FitWitWorkout.alphabetical.map{|fww| [fww.name, fww.id]}
      render action: 'coach_enters_scores'
      # and highlight errors
    end
  end

  def delete_workout
    @workout = Workout.find(params[:workout_id])
    @workout.destroy
  end

end
