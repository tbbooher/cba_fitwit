class Backend::EventsController < Backend::ResourceController
  belongs_to :location

  def index

    @events = if params['start'].present? && params['end'].present?
                Event.after(params['start']).before(params['end'])
              elsif params['start'].present?
                Event.after(params['start'])
              elsif params['end'].present?
                Event.before(params['end'])
              else
                Event.scoped.all.to_a
              end

    @location = Location.find(params[:location_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @events }
      format.js { render :json => @events }
    end

  end

end
