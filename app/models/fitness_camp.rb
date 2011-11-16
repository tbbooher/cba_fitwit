class FitnessCamp

  include Mongoid::Document

  field :title, :type => String
  field :session_start_date, :type => Date
  field :session_end_date, :type => Date
  field :session_active, :type => Boolean, default: false
  field :description, :type => String

  embedded_in :location
  embeds_many :time_slots

#  has_many :orders, :through => :registrations,
#    :uniq => true,
#    :include => :user,
#    :dependent => :destroy
  ################################################
  # VALIDATIONS                                  #
  ################################################
  validates_presence_of  :title, :session_start_date, :session_end_date

  ################################################
  # SCOPES                                       #
  ################################################
  scope :future, where(:session_start_date.gt => Date.today).and(session_active: true)
  
  #  def self.find_available_fitnesscamps
  #    find(:all) #  :order => "session_start_date")
  #  end
  
  def stdt
    self.session_start_date.strftime("%d %b %y")
  end
  
  def eddt
    self.session_end_date.strftime("%d %b %y")
  end
  
  def full_title
    "#{self.title} from #{self.stdt} to #{self.eddt}"
  end
  
  def potential_dates
    days = (self.session_start_date.day..self.session_end_date.day).map{|d| d}
    build_dates(days, self.session_start_date)
  end
  
  def potential_dates_simple
    (self.session_start_date..self.session_end_date).map{|d| [d,d.strftime("%a, %d %b")]}
    #build_dates(days, )
  end
  
  def time_slots_ordered
    TimeSlot.find(:all, :conditions => ['fitness_camp_id = ?',self.id], :order => 'start_time ASC')
  end
  
#  def bc_start_time
#    self.camp_start_time.strftime("%I:%M%p")
#  end
  
  def self.find_all_camps_in_year(my_year)
    start_of_year = Date.civil(my_year.to_i, 1, 1).to_s(:db)
    start_of_next_year = Date.civil(my_year.to_i+1.to_i, 1, 1).to_s(:db)
    my_cond = ['(session_start_date >= ? and session_start_date < ?) or (session_end_date >= ? and session_end_date < ?)',
      start_of_year,start_of_next_year,start_of_year,start_of_next_year]
    FitnessCamp.find(:all,
      :order => 'session_start_date',
      :conditions => my_cond,
      :order => 'session_start_date')
  end
  
  def self.find_upcoming(user_id)
    self.find :all,
      :joins => {:time_slots => {:registrations => {:order => :user}}},
      :conditions => ['users.id = ? AND fitness_camps.session_start_date >= ?',
      user_id, Date.today().to_s(:db)]
  end
  
  def self.find_upcoming_and_current
    FitnessCamp.find :all,
      :conditions => ['fitness_camps.session_end_date >= ?', Date.today().to_s(:db)]
  end
  
  def self.find_past(user_id)
    self.find :all,
      :joins => {:time_slots => {:registrations => {:order => :user}}},
      :conditions => ['users.id = ? AND fitness_camps.session_start_date <= ?',
      user_id,Date.today().to_s(:db)]
  end
  
  def find_registered
    # {:time_slots => {:registrations => {:order => :user}}}
    User.find :all, :select => 'distinct users.*',
      :joins => {:orders => {:registrations => {:time_slot => :fitness_camp}}},
      :conditions => ['fitness_camp_id = ?', self.id]
  end
  
  def find_user_exercises(user_id)
    Exertion.find(:all,
      :joins => {:meeting_user => {:meeting => :time_slot}},
      :conditions => ["fitness_camp_id = ? AND user_id = ?", self.id, user_id] )
  end
  
  private
  
  def build_dates(days,dt)
    dts = []
    days.each do |d|
      dt = Date.new(dt.year,dt.month,d)
      dts << [dt.strftime("%a, %d-%b"), dt.to_s(:db)]
    end
    dts
  end

end
