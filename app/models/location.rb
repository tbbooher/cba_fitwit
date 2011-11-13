class Location
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :fitness_camps, :dependent => :destroy
  has_and_belongs_to_many :sponsors
  belongs_to :franchise

  field :name, :type => String
  field :description, :type => String
  field :directions, :type => String
  field :contact_info, :type => String
  field :city, :type => String
  field :created_at, :type => DateTime
  field :updated_at, :type => DateTime
  field :franchise_id, :type => Integer
  field :us_state, :type => String
  field :short_description, :type => String
  field :zip, :type => String
  field :street_address, :type => String
  field :lat, :type => Float
  field :lon, :type => Float

  CITY_TYPES = [
      #  Displayed        stored in db
      ["Atlanta, GA", "Atlanta"],
      ["Cincinnati, OH", "Cincinnati"],
      ["Columbus, OH", "Columbus"],
      ["Toledo, OH", "Toledo"]
  ]

  US_STATES=[
      ["Alabama", "AL"],
      ["Alaska", "AK"],
      ["Arizona", "AZ"],
      ["Arkansas", "AR"],
      ["California", "CA"],
      ["Colorado", "CO"],
      ["Connecticut", "CT"],
      ["Delaware", "DE"],
      ["District Of Columbia", "DC"],
      ["Florida", "FL"],
      ["Georgia", "GA"],
      ["Hawaii", "HI"],
      ["Idaho", "ID"],
      ["Illinois", "IL"],
      ["Indiana", "IN"],
      ["Iowa", "IA"],
      ["Kansas", "KS"],
      ["Kentucky", "KY"],
      ["Louisiana", "LA"],
      ["Maine", "ME"],
      ["Maryland", "MD"],
      ["Massachusetts", "MA"],
      ["Michigan", "MI"],
      ["Minnesota", "MN"],
      ["Mississippi", "MS"],
      ["Missouri", "MO"],
      ["Montana", "MT"],
      ["Nebraska", "NE"],
      ["Nevada", "NV"],
      ["New Hampshire", "NH"],
      ["New Jersey", "NJ"],
      ["New Mexico", "NM"],
      ["New York", "NY"],
      ["North Carolina", "NC"],
      ["North Dakota", "ND"],
      ["Ohio", "OH"],
      ["Oklahoma", "OK"],
      ["Oregon", "OR"],
      ["Pennsylvania", "PA"],
      ["Rhode Island", "RI"],
      ["South Carolina", "SC"],
      ["South Dakota", "SD"],
      ["Tennessee", "TN"],
      ["Texas", "TX"],
      ["Utah", "UT"],
      ["Vermont", "VT"],
      ["Virginia", "VA"],
      ["Washington", "WA"],
      ["West Virginia", "WV"],
      ["Wisconsin", "WI"],
      ["Wyoming", "WY"]]

  def self.get_location_array
    self.find(:all).collect { |my_l| ["#{my_l.name} by #{my_l.franchise.name}", my_l.id] }
  end

  def all_users_registered_for_upcoming_camp
    User.find(:all,
              :joins => {:registrations => {:time_slot => {:fitness_camp => :location}}},
              :conditions => ['location_id = ? and session_start_date >= ?',
                              self.id, "2006-07-18"]) # Date.today.to_s(:db)
  end

#  def all_emails_for_upcoming_camp
#    User.find(:all,
#      :select => 'user.email_address',
#      :joins => {:registrations => {:time_slot => {:fitness_camp => :location}}},
#      :conditions => ['location_id = ? and session_start_date >= ?',
#        self.id,"2006-07-18"]) # Date.today.to_s(:db)
#  end

  def future_fitness_camp_count
    FitnessCamp.find(:all, :conditions => ['session_start_date >= ? and location_id = ?', Date.today.to_s(:db), self.id]).length
  end

  def self.find_all_states
    self.find(:all).map { |l| [l.us_state, l.state_full_name] }.uniq
  end

  def state_full_name
    # TODO would like to throw a meaningful error here
    US_STATES.detect { |fn, sn| sn == self.us_state }.first
  end

  def summary
    "#{self.name} in #{self.city},#{self.us_state}"
  end

  def multi_line_address
    "#{self.street_address}<br />#{self.city}, #{self.us_state} #{self.zip}"
  end

  def future_fitness_camps
    FitnessCamp.find(:all,
                     :conditions => ["location_id = ? AND session_start_date >= ? AND session_active = TRUE",
                                     self.id, Date.today().to_s(:db)])
  end

  def one_line_address
    "#{self.street_address}, #{self.city}, #{self.us_state} #{self.zip}"
  end

  def info_window
    "#{self.name}\n#{self.one_line_address}"
  end

  def name_in_context
    "#{self.name} in #{self.city}, #{self.us_state}"
  end
end