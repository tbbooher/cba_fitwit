class Event
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongoid::Timestamps

  field :title, :type => String
  field :starts_at, :type => DateTime
  field :ends_at, :type => DateTime
  field :all_day, :type => Boolean
  field :description, :type => String

  belongs_to :location

  validate :dates_correlation

  #scope :before, lambda {|end_time| {:conditions => ["ends_at < ?", Event.format_date(end_time)] }}
  #scope :after, lambda {|start_time| {:conditions => ["starts_at > ?", Event.format_date(start_time)] }}
  # re-written in Mongoid
  scope :before, ->(end_time) { where(:ends_at.lt => Event.format_date(end_time)) }
  scope :after, ->(start_time) { where(:starts_at.gt => Event.format_date(start_time)) }


  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      :id => self.id,
      :title => self.title,
      :description => self.description || "",
      :start => starts_at.rfc822,
      :end => ends_at.rfc822,
      :allDay => self.all_day,
      :recurring => false,
      :url => "test" # Rails.application.routes.url_helpers.event_path(id)
    }

  end

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end

  def dates_correlation
    @errors.add(:ends_at, "The event must end after it started") if starts_at > ends_at
  end

end
