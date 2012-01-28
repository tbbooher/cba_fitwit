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

  def camp_blog
    # probably delete, just here if we want to show calendar, etc
    # TODO -- we are not html safe rendering sidebar content!!
    @calendar = true
    @location = Location.find(:location_id).first

    @blog = Blog.where(title: @location.name).first

    _postings = @blog.postings_for_user_and_mode(current_user,draft_mode)

    @postings = _postings.desc(:created_at).paginate(:page => params[:page],:per_page => ENV['CONSTANTS_paginate_postings_per_page'].to_i)
    respond_to do |format|
      format.js {
         @path = blog_path(@blog, :page => (params[:page] ? (params[:page].to_i+1) : 2) )
      }
      format.html {render layout: "camp_blog_page"}
      format.xml  { render :xml => @blog }
    end

  end

  def camp_details

  end

  def whats_included

  end

  def faq

  end

  def price

  end

  def referrals

  end

  def non_profit

  end

  # stories
  def stories

  end

  def company_story

  end

  def camper_stories

  end

  def contact

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
