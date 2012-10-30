class FitnessCamp

  include Mongoid::Document
  include Mongoid::MultiParameterAttributes

  field :title, :type => String
  field :session_start_date, :type => Date
  field :session_end_date, :type => Date
  field :session_active, :type => Boolean, default: false
  field :description, :type => String

  belongs_to :location
  has_many :time_slots

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
  #scope :future, where(:session_start_date.gt => Date.today).and(session_active: true)
  scope :upcoming_and_current, ->() { where(:session_end_date.gte => Date.today).and(session_active: true) }
  scope :all_camps_in_year, ->(my_year) { where(start_year: my_year).or(end_year: my_year) }

  def start_year
    self.session_start_date.year
  end

  def end_year
    self.session_end_date.year
  end

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
    #days = (self.session_start_date.day..self.session_end_date.day).map{|d| d}
    #build_dates(days, self.session_start_date)
    (self.session_start_date..self.session_end_date).map{|d| [d.strftime("%a, %d-%b"), d.to_s(:db)]}
  end
  
  def potential_dates_simple
    (self.session_start_date..self.session_end_date).map{|d| [d,d.strftime("%a, %d %b")]}
  end

  def months_and_years
    m = []
    d = self.session_start_date.beginning_of_month
    while d <= self.session_end_date.beginning_of_month
      m << [d.month, d.year]
      d = d.next_month
    end
    return m
  end

  
end
