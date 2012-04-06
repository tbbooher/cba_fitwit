class Backend::FitWitWorkoutsController <  Backend::ResourceController
  respond_to :json

  def index
    @fit_wit_workouts = FitWitWorkout.asc(:name).page params[:page]
    index!
  end

end
