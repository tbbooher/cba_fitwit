class Backend::MeetingsController < Backend::ResourceController
  belongs_to :location
  belongs_to :fitness_camp
  belongs_to :time_slot
  respond_to :js, :only => [:take_attendance, :destroy]
  respond_to :json, :only => :index

  def take_attendance
    @meeting = Meeting.find(params[:meeting_id])
    @time_slot = TimeSlot.find(params[:time_slot_id])
    @location = Location.find(params[:location_id])
    @fitness_camp = FitnessCamp.find(params[:fitness_camp_id])
    unless params[:user_ids].nil?
      @meeting.attendees = params[:user_ids].map{|uid| User.find(uid)}
    else
      @meeting.attendees.clear
    end
    # redirect
    respond_to do |format|
      if @meeting.save
        format.html { redirect_to(:back, :notice => "Successful Update") }
        format.js
      else
        format.html { redirect_to(:back, :notice => 'Error!') }
        format.js
      end
    end
  end

  def add_meetings
    @time_slot = TimeSlot.find(params[:time_slot_id]) # from url
    @meeting_dates = params[:meeting_dates].split(",").map{|m| m.split("/").map(&:to_i)}.map{|r| Date.civil(r[2],r[0],r[1])} # from form
    @meetings = Meeting.all.to_a
    if params[:commit] == "Apply to this time slot"
      @time_slot.add_meetings(@meeting_dates)
    else
      @time_slot.add_meetings_for_every_ts(@meeting_dates)
    end
    respond_to do |format|
      if @time_slot.save
        format.html { redirect_to(:back, :notice => "Successfully added all meetings for camp.") }
        format.js
      else
        format.html { redirect_to(:back, :notice => 'Error!') }
        format.js
      end
    end
  end

  def show_workout_results
    @meeting = Meeting.find(params[:meeting_id])
    @workouts = @meeting.workouts.group_by(&:fit_wit_workout_id)
  end
end
