class Meeting

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  field :meeting_date, type: Date

  belongs_to :time_slot
  has_and_belongs_to_many :attendees, class_name: "User", inverse_of: :attendances
  has_many :workouts, autosave: true

  accepts_nested_attributes_for :workouts, allow_destroy: true # , reject_if: lambda {|a| a[:score].blank? }, allow_destroy: true

  def meeting_date_f
    self.meeting_date.strftime("%d-%b")
  end
  
  # we want to know if a user attended this class . . .
  def attended?(user)
    self.attendees.include?(user)
    # self.users.map{|user| user.id }.include?(user_id)
  end

  def full_context
    "#{self.time_slot.short_title} on #{meeting_date_f}"
  end

  def start_time
    m = self.meeting_date
    t = self.time_slot.start_time
    Time.local(m.year, m.month, m.day, t.hour, t.min)
  end

  def attendance_color(user)
    if self.attended?(user)
      "#dedede"
    else
      if self.meeting_date > Date.today()
        "white"
      else
        "#cecece"
      end
    end
  end

  def as_json(options={})
    {
      :id => 'blank',
      :title => 'Camp',
      :description => self.time_slot.short_title || "",
      :start => self.start_time.rfc822,
      :end => 1.hour.from_now(self.start_time).rfc822,
      :allDay => false,
      :recurring => false,
      :url => "" # Rails.application.routes.url_helpers.event_path(id)
    }
  end

end
