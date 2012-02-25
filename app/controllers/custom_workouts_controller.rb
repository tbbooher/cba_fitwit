class CustomWorkoutsController < ApplicationController
  before_filter :get_user

  # POST /custom_workouts
  # POST /custom_workouts.json
  def create
    @custom_workout = @user.custom_workouts.new(params[:custom_workout])

    respond_to do |format|
      if @custom_workout.save
        # TODO need to get a specific month in there . . .
        format.html { redirect_to my_fit_wit_fit_wit_workout_progress_path, notice: 'Custom workout was successfully created.' }
        format.json { render json: @custom_workout, status: :created, location: @custom_workout }
      else
        format.html { render controller: "my_fit_wit", action: "add_custom_workout" }
        format.json { render json: @custom_workout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /custom_workouts/1
  # PUT /custom_workouts/1.json
  def update
    @custom_workout = @user.custom_workouts.find(params[:id])

    respond_to do |format|
      if @custom_workout.update_attributes(params[:custom_workout])
        format.html { redirect_to my_fit_wit_fit_wit_workout_progress_path, notice: 'Custom workout was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render controller: "my_fit_wit", action: "show_custom_workout" }
        format.json { render json: @custom_workout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_workouts/1
  # DELETE /custom_workouts/1.json
  def destroy
    @custom_workout = @user.custom_workouts.find(params[:id])
    @custom_workout.destroy

    respond_to do |format|
      format.html { redirect_to my_fit_wit_fit_wit_workout_progress_path }
      format.json { head :ok }
    end
  end

  private

  def get_user
    @user = User.find(params[:user_id])
  end
end
