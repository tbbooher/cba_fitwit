class TimeSlot

  include Mongoid::Document

  field :fitness_camp_id, :type => Integer
  field :start_time, :type => Time
  field :end_time, :type => Time
  field :sold_out, :type => Boolean

  belongs_to :fitness_camp
  #has_many :meetings, :dependent => :destroy
  has_many :registrations, :dependent => :destroy
  has_many :prizes, :dependent => :destroy
  
  def start_time_f
    self.start_time.strftime(" %I:%M%p").gsub(/ 0(\d\D)/, '\1')
  end
  
  def end_time_f
    self.end_time.strftime(" %I:%M%p").gsub(/ 0(\d\D)/, '\1')
  end

  def campers
    self.registrations.map{|r| r.order.user.full_name}
  end
  
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
  
  #  def long_title
  #    fitness_camp = self.fitness_camp
  #    "#{fitness_camp.title} on #{self.meeting.meeting_date_f} at #{self.start_time_f}"
  #  end
  
  def start_to_finish
    "#{start_time_f} to #{end_time_f}"
  end
  
  def meeting_dates
    self.meetings.map{|m| m.meeting_date}.sort
  end
  
  def who_is_going
    # newer push
    User.find(:all, :select => 'users.*, user_id, registrations.id',
      :joins => {:orders => {:registrations => :time_slot}},
      :order => 'first_name',
      :conditions => ['time_slot_id = ?', self.id])
  end
  
  def users_going
    # newer push
    User.find(:all, 
      :joins => {:orders => {:registrations => :time_slot}},
      :order => 'first_name',
      :conditions => ['time_slot_id = ?', self.id])
  end
  
  def who_is_not_going
    # newer push
    #(User.find(:all) - @attendees)
    User.find_by_sql(["(select * from users" +
          " where id NOT IN (SELECT users.id FROM `users` INNER JOIN `orders` ON orders.user_id = users.id INNER JOIN `registrations` ON registrations.order_id = orders.id INNER JOIN `time_slots` ON `time_slots`.id = `registrations`.time_slot_id WHERE (time_slot_id = ?))) ORDER BY last_name", self.id])
  end
  
  def all_prizes
    Prize.find(:all, :conditions => ["time_slot_id = ?", self.id])
  end
  
  private
  
  def strip_zeros_from_date(marked_date_string)
    cleaned_string = marked_date_string.gsub('*0', '').gsub('*', '')
    return cleaned_string
  end
end
