class CalendarController < ApplicationController
  
  def events
    @events = Event.where(location_id: params[:id]).all.to_a
    @event_days = @events.group_by {|t| t.starts_at.beginning_of_day }
    # we want to group these by day and get them in the format:
    #      events = [
    #    Title: "Five K for charity " + this.id
    #    Date: new Date("01/13/2012")
    #  ,
    #    Title: "Dinner"
    #    Date: new Date("01/25/2012")
    #  ,
    #    Title: "Meeting with manager"
    #    Date: new Date("01/01/2012")
    #  ]

    out = @event_days.map{|day, events| {Date: day.strftime('%m/%d/%Y'), Title: events.map(&:title).to_sentence}}

    render json: out.to_json
  end

  def all_camp_events
    # need to display this as json
    l = Location.find(params[:id])
    #l = Location.first
    events = l.all_meetings
    render json: events.to_json
  end

  def all_events
    events = Event.scoped.all.to_a
    events = Event.after(params['start']) if (params['start'])
    events = Event.before(params['end']) if (params['end'])
    # we want to group these by day and get them in the format:
    #      events = [
    #    Title: "Five K for charity " + this.id
    #    Date: new Date("01/13/2012")
    #  ,
    #    Title: "Dinner"
    #    Date: new Date("01/25/2012")
    #  ,
    #    Title: "Meeting with manager"
    #    Date: new Date("01/01/2012")
    #  ]

    render json: events.to_json
  end

  def foo
    @events = Event
    @events = Event.after(params['start']) if (params['start'])
    @events = Event.before(params['end']) if (params['end'])
    @location = Location.find(params[:location_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @events }
      format.js { render :json => @events }
    end
  end

end
