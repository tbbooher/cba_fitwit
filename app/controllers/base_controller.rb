class BaseController < ApplicationController
  skip_before_filter :check_authentication, :check_authorization
  caches_page :home, :community, :about_us, :not_authorized, :logoff_success, :all_sponsors

  # TODO REMOVE THIS
  def error
    raise RuntimeError, "Generating an error"
  end

  def home
    @bigpic = true
    @news_items = NewsItem.where(display: true) #find(:all, :conditions => 'display = true', :order => 'created_at DESC')
    #schedule_data
  end

  def create_your_own_fitwit
    @pagetitle = "Create Your Own FitWit"
  end

  def community
    @pagetitle = "FitWit Community"
  end

  def contact_us
    @pagetitle = "Contact Us"
    @fit_wit_form = true
    @message = ContactMessage.new
    if request.post?
      @message.attributes = params[:message]
      if @message.valid?
        name = @message.name
        email = @message.email
        subject = @message.subject ||= "no subject"
        the_message = @message.message ||= "no message"
        email = Postman.create_new_contact(name, email, subject, the_message)
        if Postman.deliver(email)
          flash[:notice] = "Thank you, #{name}, your message has been sent"
          redirect_to :action => 'contact_us'
        else
          flash[:notice] = myflash ||= "error in send"
          redirect_to :action => 'contact_us'
        end
      end
    end
  end

  def about_us
    @pagetitle = "Our Story"
  end

  def not_authorized
    @pagetitle = "Not Authorized"
  end

  def login_success
    @pagetitle = "Successful Login"
    @locations = Location.find(:all)
    @user = User.find_by_id(session[:user_id])
  end

  def logoff_success
    @pagetitle = "Successful Logoff"
  end

  def all_sponsors
    @pagetitle = "All FitWit Sponsors"
    @sponsors = Sponsor.find(:all)
  end
end
