class Backend::TimeSlotsController < Backend::ResourceController
  nested_belongs_to :location, :fitness_camp
  respond_to :json, only: :show

  def delete_user
    @user_id = params[:user_id]
    @user_name = User.find(@user_id).full_name
    @registration = Registration.where(user_id: @user_id).and(time_slot_id: params[:time_slot_id]).first
    @time_slot = @registration.time_slot
    respond_to do |format|
      if @registration.delete
        format.html { redirect_to(:back, :notice => "Successfully added user to fitness camp.") }
        format.js
      else
        format.html { redirect_to(:back, :notice => 'Error!') }
        format.js
      end
    end
  end

  def register_user
    time_slot = TimeSlot.find(params[:time_slot_id])
    @registration = time_slot.create_user_registration(params[:user_id])
    respond_to do |format|
      if @registration.save
        format.html { redirect_to(:back, :notice => "Successfully added user to fitness camp.") }
        format.js
      else
        format.html { redirect_to(:back, :notice => 'Error!') }
        format.js
      end
    end
  end

  def  attendance_sheet
    # here we need a list of all users in a time slot
    ts = TimeSlot.find(params[:time_slot_id])
    @campers = ts.all_campers

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @campers}
      format.pdf do
        pdf = AttendanceReportPdf.new(ts, @campers, view_context)
        send_data pdf.render, filename: "Attendance_Report_For_#{ts.longer_title.parameterize}.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end
 
  def emergency_contact
    ts = TimeSlot.find(params[:time_slot_id])
    @campers = ts.all_campers

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @campers}
      format.csv { render :csv => @campers}
      format.pdf do
        pdf = CampRosterPdf.new(ts, @campers, view_context)
        send_data pdf.render, filename: "Emergency_Contact_List_For_#{ts.short_title.parameterize}.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  def re_register
    @location = Location.find(params[:location_id])
    @fitness_camp = FitnessCamp.find(params[:fitness_camp_id])
    @time_slot = TimeSlot.find(params[:time_slot_id])
    @start_time = @time_slot.start_time
    @previous_time_slot = @location.
      find_previous_camp(@time_slot.start_time, @fitness_camp)
    all_previous_campers = @previous_time_slot.
      registrations.map{|r| r.user}.flatten
    @all_previous_members = all_previous_campers.select{|u| u.member}
    @previous_non_members = all_previous_campers - @all_previous_members
  end

  def process_repeat_registrations
    # only html request
    # here we re-register the members
    # I think we need some error checking here . . .
    time_slot = TimeSlot.find(params[:time_slot_id])
    params[:user_ids].each do |member_id|
      time_slot.register_user(member_id)
    end
    flash[:notice] = "Successfully added #{params[:user_ids].size} members to #{time_slot.short_title}."
    fc= time_slot.fitness_camp
    redirect_to backend_location_fitness_camp_time_slot_path(fc.location.id, fc.id, time_slot.id)
  end

end
