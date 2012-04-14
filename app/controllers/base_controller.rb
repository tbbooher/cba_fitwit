class BaseController < ApplicationController
  # need to update this! TODO -- UPDATE
  #caches_page :getting_started, :locations, :fit_wit_calendar, :camp_details, :whats_included, :faq, :price, :non_profit, :team_story, :company_story, :camper_stories, :contact, :amanda, :arthur_and_anna, :brandi, :catherine, :christina, :dawn, :denise, :greg, :jose, :katherine, :lisa, :mary, :mike
  #cache_sweeper :offer_sweeper
  layout "canvas"

  def posts
    @blog = Blog.where(:title => t(:news)).first
    if @blog
      @postings = @blog.postings.desc(:created_at).paginate(
        :page => params[:page],
        :per_page => ENV['CONSTANTS_paginate_postings_per_page'].to_i
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
    @offer = Offer.where(active: true).desc(:updated_at).first
  end

  def locations
    @locations = Location.all.to_a
    @google_maps = true
  end

  def fit_wit_calendar
    # here we load the common calendar

  end

  def camp_details
    @camp_details = true
  end

  def whats_included
    @offer = Offer.where(active: true).desc(:updated_at).first
    @camp_details = true
  end

  def faq
    @camp_details = true
  end

  def price
    @camp_details = true
    @offer = Offer.where(active: true).desc(:updated_at).first
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
      Notifications.confirmation_to_user(@message).deliver
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
