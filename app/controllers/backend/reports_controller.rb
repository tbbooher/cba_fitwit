class Backend::ReportsController <  Backend::ApplicationController

  def index

  end

  def fitwit_member_info
    @users = User.camps_than_name.where(:member => true)

    respond_to do |format|
      format.html
      format.csv { render text: @users.member_info_to_csv}
    end
  end

  def all_fitwit_users_info
    @users = User.camps_than_name

    respond_to do |format|
      format.html
      format.csv  { render text: @users.all_fitwit_users_info_to_csv }
    end
  end

end
