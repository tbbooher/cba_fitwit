class Backend::ReportsController <  Backend::ApplicationController

  def index

  end

  def fitwit_member_info
    if params[:location_id]
      @users = User.sort_by_location_then_name.where(:member => true).and(location_id: params[:location_id])
    else
      @users = User.sort_by_location_then_name.where(:member => true)
    end

    respond_to do |format|
      format.html
      format.csv { render text: @users.member_info_to_csv}
    end
  end

  def all_fitwit_users_info
    @users = User.sort_by_location_then_name

    respond_to do |format|
      format.html
      format.csv  { render text: @users.all_fitwit_users_info_to_csv }
    end
  end

end
