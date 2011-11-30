class TimeSlot

  include Mongoid::Document
  include Mongoid::MultiParameterAttributes

  field :start_time, :type => Time
  field :end_time, :type => Time
  field :sold_out, :type => Boolean

  belongs_to :fitness_camp

  has_many :registrations
  has_many :meetings
  embeds_many :prizes
  
  def start_time_f
    self.start_time.strftime(" %I:%M%p").gsub(/ 0(\d\D)/, '\1')
  end
  
  def end_time_f
    self.end_time.strftime(" %I:%M%p").gsub(/ 0(\d\D)/, '\1')
  end

  def user_fit_wit_workouts(user_id)
    meeting_ids = self.meetings.map(&:id)
    Workout.where(user_id: user_id).and(:meeting_id.in => meeting_ids).to_a
  end

  def campers
    self.registrations.map{|r| r.order.user.full_name}
  end
  
  #  def find_registered
    # TODO -- we must know everyone registered for this time slot
    # {:time_slots => {:registrations => {:order => :user}}}
    #User.find :all, :select => 'distinct users.*',
    #  :joins => {:orders => {:registrations => {:time_slot => :fitness_camp}}},
    #  :conditions => ['fitness_camp_id = ?', self.id]
#  end

  def show_meeting_txt
    "<span class=\"time\">#{self.start_time_f}</span>\n" +
    "<span class=\"time\"> to #{self.end_time_f}</span>"
  end
  
  def short_title
    fitness_camp_title = self.fitness_camp.title
    "#{fitness_camp_title} at #{self.start_time_f}"
  end
  
  def longer_title
    fitness_camp_title = self.fitness_camp.title
    location = self.fitness_camp.location.name
    "#{fitness_camp_title} at #{self.start_time_f} located at #{location}"
  end
  
  def start_to_finish
    "#{start_time_f} to #{end_time_f}"
  end
  
  def meeting_dates
    self.meetings.map{|m| m.meeting_date}.sort
  end
  
  def who_is_going
    # newer push
    self.registrations.map{|r| [r.order.user, r.order.user.id, r.id]}
    # User.find(:all, :select => 'users.*, user_id, registrations.id',
    #   :joins => {:orders => {:registrations => :time_slot}},
    #   :order => 'first_name',
    #   :conditions => ['time_slot_id = ?', self.id])
  end
  
  def users_going
    # newer push
    self.registrations.map{|r| r.order.user}
    # User.find(:all, 
    #   :joins => {:orders => {:registrations => :time_slot}},
    #   :order => 'first_name',
    #   :conditions => ['time_slot_id = ?', self.id])
  end
  
  def who_is_not_going
    # newer push
    #(User.find(:all) - @attendees)
    # TODO -- really inefficient -- must delete!
    User.all - self.users_going
  end

  # really not needed this is just a property of the association
  #def all_prizes
  #  self.prizes
  #  Prize.find(:all, :conditions => ["time_slot_id = ?", self.id])
  # end
  
  # private
  
  # def strip_zeros_from_date(marked_date_string)
  #   cleaned_string = marked_date_string.gsub('*0', '').gsub('*', '')
  #   return cleaned_string
  # end
end
