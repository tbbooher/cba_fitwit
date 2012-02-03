class BaseController < ApplicationController
  caches_page :home, :community, :about_us, :not_authorized, :logoff_success, :all_sponsors
  layout "canvas"

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

  def getting_started
    @camp_details = true
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

  def locations
    @locations = Location.all.to_a
    @google_maps = true
  end

  def not_authorized
    @pagetitle = "Not Authorized"
  end

  def fit_wit_calendar
    # here we load the common calendar

  end

  def camp_details
    @offer = Offer.where(active: true).desc(:updated_at).first
    @camp_details = true
  end

  def whats_included
    @camp_details = true
  end

  def faq
    @camp_details = true
  end

  def price
    @camp_details = true
  end

  def referrals

  end

  def non_profit

  end

  # stories
  def team_story
    @stories = true
  end

  def company_story
    @stories = true
  end

  def camper_stories
    @stories = true
  end

  def contact
    @message = Message.new
  end

  def create_contact_message
    @message = Message.new(params[:message])

    if @message.valid?
      Notifications.send_contact_message(@message).deliver
      redirect_to(root_path, :notice => "Thank you, your message was successfully sent.")
    else
      flash.now.alert = "Please fill all required fields."
      render :contact
    end
  end

  def amanda

  end

  def arthur_and_anna

  end

  def brandi

  end

  def catherine

  end

  def christina

  end

  def dawn

  end

  def denise

  end

  def greg

  end

  def jose

  end

  def katherine

  end

  def lisa

  end

  def mary

  end

  def mike

  end

end
