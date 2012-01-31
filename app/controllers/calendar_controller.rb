class CalendarController < ApplicationController

  def events
    # this is for the sidebar calendar
    @events = Event.where(location_id: params[:id]).all.to_a
    @event_days = @events.group_by {|t| t.starts_at.beginning_of_day }

    out = @event_days.map{|day, events| {Date: day.strftime('%m/%d/%Y'), Title: events.map(&:title).to_sentence}}

    render json: out.to_json
  end

  def all_camp_events
    # need to display this as json
    l = Location.find(params[:id])
    #l = Location.first
    events = l.all_meetings
    # need to scope
    render json: events.to_json
  end

  def all_events
    events = if params['start'].present? && params['end'].present?
                Event.after(params['start']).before(params['end'])
              elsif params['start'].present?
                Event.after(params['start'])
              elsif params['end'].present?
                Event.before(params['end'])
              else
                Event.scoped.all.to_a
              end

    render json: events.to_json
  end

  def location_calendar
    @location = Location.find(params[:location_id])
  end

  def fit_wit_calendar

  end

  def display_event
    # this will give the details on an event
  end

end
