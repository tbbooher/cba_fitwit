class Backend::UsersController < Backend::ResourceController
  def index
    @locations = Location.all
    @location_id = params[:location]
    if @location_id
      if @location_id == 'None'
        @users = User.where(location_id: nil).page params[:page]
      else
        @users = User.where(location_id: @location_id).page params[:page]
      end
    else
      @user = User.all.page params[:page]
    end
  end
end
