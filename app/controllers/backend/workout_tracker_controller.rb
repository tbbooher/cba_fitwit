class Backend::WorkoutTrackerController < Backend::ApplicationController

  # this whole controller might be un-necessary -- we should treat 
  # workouts as a nested attribute of meeting

  def add_workout_for_user
    @user = User.find(params[:user_id])
    @meeting = Meeting.find(params[:meeting_id])
    @time_slot = @meeting.time_slot
    @fitness_camp = @time_slot.fitness_camp
    @location = @fitness_camp.location
    @users_workouts = @meeting.camp_workouts.map{|cw| cw.workouts}.flatten.where(user_id: @user.id).all.to_a
    #@exertions = Exertion.find(:all,:conditions => ['meeting_user_id = ?',@meeting_user_id])
    @other_attendees = @meeting.attendees.to_a - @user.to_a
  end

  def coach_enters_scores
    @meeting = Meeting.find(params[:meeting_id])
    @time_slot = @meeting.time_slot
    @fitness_camp = @time_slot.fitness_camp
    @location = @fitness_camp.location
    @cwo =  @meeting.camp_workouts.new
    @meeting.attendees.asc(:first_name).each do |user|
      @cwo.workouts.build(user_id: user.id)
    end
    #@possible_workouts = [["You must select a workout", 0]] +  FitWitWorkout.all.map{|fww| [fww.name, fww.id]}
  end

  def update_workout_for_user
    # action_method
    @user = User.find(params[:user_id])
    @w = Workout.new
    @w.user_id = @user.id
    @w.rxd = params[:rxd]
    @w.user_note = params[:user_note]
    @w.score = params[:score]
    @w.fit_wit_workout_id = params[:fit_wit_workout_id]
    @w.meeting_id = params[:meeting_id]
    @w.save
  end

  def update_workouts_for_camp
    @meeting = Meeting.find(params[:meeting_id])
    ts = @meeting.time_slot
    fc = ts.fitness_camp
    l = fc.location.id
    if @meeting.update_attributes(params[:meeting])
      flash[:notice] = "Successfully recorded all workouts"
      redirect_to  backend_location_fitness_camp_time_slot_meeting(l,fc.id,ts.id,@meeting.id)
    else
      render action: 'coach_enters_scores'
      # and highlight errors
    end    

    # # workouts_method
    # @fww = FitWitWorkout.find(params[:fit_wit_workout_id])
    # params = params
    # @workouts = []
    # params[:workouts].each do |s|
    #   w = Workout.new
    #   w.user_id    = s[:user_id]
    #   w.score      = s[:score]
    #   w.user_note  = s[:note]
    #   w.rxd        = s[:rxd]
    #   w.fit_wit_workout_id = params[:fit_wit_workout_id]
    #   w.meeting_id         = params[:meeting_id]
    #   w.save
    #   @workouts << w
    # end
  end

  def delete_workout
    @workout = Workout.find(params[:workout_id])
    @workout.destroy
  end

end
