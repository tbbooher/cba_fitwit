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
    o = Order.new
    o.user = @user
    o.description = "FitWit Administratively Generated Order"
    o.save
    @registration.user = @user
    @registration.order = o
    @registration.time_slot = @time_slot
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

end
