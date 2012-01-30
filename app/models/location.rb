class Location
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :fitness_camps
  has_many :events
  has_and_belongs_to_many :sponsors

  field :name, :type => String
  field :description, :type => String
  field :contact_info, :type => String
  field :street_address, :type => String
  field :city, :type => String
  field :us_state, :type => String
  field :zip, :type => String
  field :active, type: Boolean
  field :lat, :type => Float
  field :lon, :type => Float

  validates_presence_of :name, :lat, :lon, :description

  def all_meetings
    self.fitness_camps.map{|fc| fc.time_slots.map{|ts| ts.meetings.map{ |m| m } } }.flatten
  end
  
  # named scopes

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

  def find_previous_camp(start_time, current_camp)
    (self.fitness_camps-current_camp.to_a).map{|fc| fc.time_slots}.flatten.
      select{|t| t.start_time.hour == start_time.hour && t.start_time.min == start_time.min}.
      sort_by{|ts| ts.fitness_camp.session_start_date}.reverse.first
  end

  def future_fitness_camps
    self.fitness_camps.future.all.to_a
  end

  def future_fitness_camp_count
    self.future_fitness_camps.size
  end

  def self.find_all_states
    Location.all.map { |l| [l.us_state, l.state_full_name] }.uniq
  end

  def state_full_name
    # TODO would like to throw a meaningful error here
    US_STATES.detect { |fn, sn| sn == self.us_state.upcase }.first
  end

  def summary
    "#{self.name} in #{self.city},#{self.us_state}"
  end

  def multi_line_address
    "#{self.street_address}<br />#{self.city}, #{self.us_state} #{self.zip}"
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
