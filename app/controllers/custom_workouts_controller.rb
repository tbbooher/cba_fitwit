class CustomWorkoutsController < ApplicationController
  # GET /custom_workouts
  # GET /custom_workouts.json
  def index
    @custom_workouts = CustomWorkout.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @custom_workouts }
    end
  end

  # GET /custom_workouts/1
  # GET /custom_workouts/1.json
  def show
    @custom_workout = CustomWorkout.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @custom_workout }
    end
  end

  # GET /custom_workouts/new
  # GET /custom_workouts/new.json
  def new
    @custom_workout = CustomWorkout.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @custom_workout }
    end
  end

  # GET /custom_workouts/1/edit
  def edit
    @custom_workout = CustomWorkout.find(params[:id])
  end

  # POST /custom_workouts
  # POST /custom_workouts.json
  def create
    @custom_workout = CustomWorkout.new(params[:custom_workout])

    respond_to do |format|
      if @custom_workout.save
        format.html { redirect_to @custom_workout, notice: 'Custom workout was successfully created.' }
        format.json { render json: @custom_workout, status: :created, location: @custom_workout }
      else
        format.html { render action: "new" }
        format.json { render json: @custom_workout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /custom_workouts/1
  # PUT /custom_workouts/1.json
  def update
    @custom_workout = CustomWorkout.find(params[:id])

    respond_to do |format|
      if @custom_workout.update_attributes(params[:custom_workout])
        format.html { redirect_to @custom_workout, notice: 'Custom workout was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @custom_workout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_workouts/1
  # DELETE /custom_workouts/1.json
  def destroy
    @custom_workout = CustomWorkout.find(params[:id])
    @custom_workout.destroy

    respond_to do |format|
      format.html { redirect_to custom_workouts_url }
      format.json { head :ok }
    end
  end
end
