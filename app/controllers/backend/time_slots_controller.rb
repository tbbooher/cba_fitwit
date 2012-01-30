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
    @registration = Registration.new
    @user = User.find(params[:user_id])
    @time_slot = TimeSlot.find(params[:time_slot_id])
    @registration.user_id = @user.id
    @registration.time_slot_id = @time_slot.id
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
    @fitness_camp_id = params[:fitness_camp_id]
    @time_slot = TimeSlot.find(params[:time_slot_id])
    @all_previous_members = @location.
      find_previous_camp(@time_slot.start_time.hour).
      registrations.map{|r| r.user}.
      select{|u| u.member}
  end

  def process_repeat_registrations
    # here we re-register the members
  end

end
