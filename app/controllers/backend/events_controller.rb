class Backend::EventsController < Backend::ResourceController
  belongs_to :location
  def index
    # full_calendar will hit the index method with query parameters
    # 'start' and 'end' in order to filter the results for the
    # appropriate month/week/day.  It should be possible to change
    # this to be starts_at and ends_at to match rails conventions.
    # I'll eventually do that to make the demo a little cleaner.
    @events = Event.scoped.all.to_a
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
