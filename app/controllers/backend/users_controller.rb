class Backend::UsersController < Backend::ResourceController
  def index
    params[:direction] ||= "asc"
    params[:order] ||= "last_name"
    @locations = Location.all
    @location_id = params[:location]
    if @location_id && (@location_id != "All")
      if @location_id == 'None'
        users_at_location = User.where(location_id: nil)
      else
        users_at_location = User.where(location_id: @location_id)
      end
    else
      users_at_location = User.all
    end

    @users = users_at_location.order_by([params[:order].to_sym,params[:direction].to_sym]).page(params[:page]).per(200)

    respond_to do |format|
       format.js
       format.html
    end
  end

  def create
    # untested
    params[:user][:password] = "iluvfitwit"
    params[:user][:password_confirmation] = "iluvfitwit"
    super
  end

end
