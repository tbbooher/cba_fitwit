class BaseController < ApplicationController
  caches_page :home, :community, :about_us, :not_authorized, :logoff_success, :all_sponsors
  layout "canvas"

  # TODO REMOVE THIS
  def error
    raise RuntimeError, "Generating an error"
  end

  def home
    # TODO -- delete?
    @bigpic = true
    @news_items = NewsItem.where(display: true) #find(:all, :conditions => 'display = true', :order => 'created_at DESC')
    #schedule_data
  end

  def posts
    @blog = Blog.where(:title => t(:news)).first
    if @blog
      @postings = @blog.postings.desc(:created_at).paginate(
        :page => params[:page],
        :per_page => CONSTANTS['paginate_postings_per_page'].to_i
      )
    end
    respond_to do |format|
       format.js {
         @path = blog_path(@blog, :page => (params[:page] ? (params[:page].to_i+1) : 2))
         render :posts
       }
       format.html { render :posts }
    end
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

  def locations
    #@google_maps = true
  end

  def camp_details

  end

  def whats_included

  end

  def faq

  end

  def price

  end

  def schedule

  end

  def non_profit

  end

  def stories

  end

  def company_story

  end

  def camper_stories

  end

  def contact

  end
end
