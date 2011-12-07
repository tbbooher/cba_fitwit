class Backend::WorkoutTrackerController < Backend::ApplicationController

  def add_workout_for_user
    @user = User.find(params[:user_id])
    @meeting = Meeting.find(params[:meeting_id])
    @time_slot = @meeting.time_slot
    @fitness_camp = @time_slot.fitness_camp
    @location = @fitness_camp.location
    @users_workouts = @meeting.workouts.where(user_id: @user.id).all.to_a
    #@exertions = Exertion.find(:all,:conditions => ['meeting_user_id = ?',@meeting_user_id])
    @other_attendees = @meeting.attendees.to_a - @user.to_a
  end

  def coach_enters_scores
    @meeting = Meeting.find(params[:meeting_id])
    @possible_workouts = [["You must select a workout", 0]] +  FitWitWorkout.all.map{|fww| [fww.name, fww.id]}
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
    # workouts_method
  end

  def delete_workout
    @workout = Workout.find(params[:workout_id])
    @workout.destroy
  end

end
