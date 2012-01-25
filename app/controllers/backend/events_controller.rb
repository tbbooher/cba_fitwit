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

  # PUT /events/1
  # PUT /events/1.xml
  # PUT /events/1.js
  # when we drag an event on the calendar (from day to day on the month view, or stretching
  # it on the week or day view), this method will be called to update the values.
  # viv la REST!
  def update
    @event = Event.find(params[:id])


    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml { head :ok }
        format.js { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @event.errors, :status => :unprocessable_entity }
        format.js { render :js => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

end
