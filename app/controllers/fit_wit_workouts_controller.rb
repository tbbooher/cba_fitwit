class FitWitWorkoutsController < ApplicationController
  # GET /fit_wit_workouts
  # GET /fit_wit_workouts.json
  def index
    @fit_wit_workouts = FitWitWorkout.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fit_wit_workouts }
    end
  end

  # GET /fit_wit_workouts/1
  # GET /fit_wit_workouts/1.json
  def show
    @fit_wit_workout = FitWitWorkout.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fit_wit_workout }
    end
  end

  # GET /fit_wit_workouts/new
  # GET /fit_wit_workouts/new.json
  def new
    @fit_wit_workout = FitWitWorkout.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fit_wit_workout }
    end
  end

  # GET /fit_wit_workouts/1/edit
  def edit
    @fit_wit_workout = FitWitWorkout.find(params[:id])
  end

  # POST /fit_wit_workouts
  # POST /fit_wit_workouts.json
  def create
    @fit_wit_workout = FitWitWorkout.new(params[:fit_wit_workout])

    respond_to do |format|
      if @fit_wit_workout.save
        format.html { redirect_to @fit_wit_workout, notice: 'Fit wit workout was successfully created.' }
        format.json { render json: @fit_wit_workout, status: :created, location: @fit_wit_workout }
      else
        format.html { render action: "new" }
        format.json { render json: @fit_wit_workout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fit_wit_workouts/1
  # PUT /fit_wit_workouts/1.json
  def update
    @fit_wit_workout = FitWitWorkout.find(params[:id])

    respond_to do |format|
      if @fit_wit_workout.update_attributes(params[:fit_wit_workout])
        format.html { redirect_to @fit_wit_workout, notice: 'Fit wit workout was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @fit_wit_workout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fit_wit_workouts/1
  # DELETE /fit_wit_workouts/1.json
  def destroy
    @fit_wit_workout = FitWitWorkout.find(params[:id])
    @fit_wit_workout.destroy

    respond_to do |format|
      format.html { redirect_to fit_wit_workouts_url }
      format.json { head :ok }
    end
  end
end
