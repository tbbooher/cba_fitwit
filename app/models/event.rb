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

  validates :title, presence: true
  validates :starts_at, presence: true, is_a_date: true
  validates :ends_at, presence: true, is_a_date: true

  #scope :before, lambda {|end_time| {:conditions => ["ends_at < ?", Event.format_date(end_time)] }}
  #scope :after, lambda {|start_time| {:conditions => ["starts_at > ?", Event.format_date(start_time)] }}
  # re-written in Mongoid
  scope :before, ->(end_time) { where(:ends_at.lt => Event.format_date(end_time)) }
  scope :after, ->(start_time) { where(:starts_at.gt => Event.format_date(start_time)) }
  scope :in_the_next_four_weeks, ->(location_id) { where(location_id: location_id).and(:starts_at.lt => 4.weeks.from_now )}

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
    if starts_at && ends_at
      @errors.add(:ends_at, "The event must end after it started") if starts_at > ends_at
    else
      unless starts_at
        @errors.add(:starts_at, "You need to add a start time")
      else
        @errors.add(:end_at, "You need to add a end time")
      end
    end
  end

end
