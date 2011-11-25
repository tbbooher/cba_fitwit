module FitWitCustomUserMethods

  # TODO -- include this in a module?
  def camper_since
    self.orders.sort_by { |o| o.created_at }.first.created_at
  end

  def find_prs
    self.prs
  end

  def past_fitness_camps
    self.user_time_slots.map{|ts| ts.fitness_camp}.uniq
  end

  def user_time_slots
    order_ids = Order.where(user_id: self.id).all.map(&:id)
    Registration.where(:order_id.in => order_ids).map{|r| r.time_slot} 
  end

  def time_slots
    user_time_slots
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def short_name
    "#{first_name} #{last_name.first}"
  end

  def home_address
    s = "#{self.street_address1}<br />\n"
    s += "#{self.street_address2}<br />\n" unless self.street_address2.empty?
    s += "#{self.city}, #{self.us_state} #{self.zip}"
    s
  end

  def age
    # datediff
    if (defined? self.date_of_birth) && self.date_of_birth.is_a?(Date)
      age = (Date.today.year - self.date_of_birth.year)
      age -= 1 if Date.today.yday < self.date_of_birth.yday
      return age
    else
      return "no dob recorded!"
    end
  end

  def dob
    self.date_of_birth.strftime("%d %b %y")
  end

  def sex
    if (defined? self.gender)
      if self.gender == 1
        mysex = "male"
      else
        mysex = "female"
      end
      return mysex
    else
      return "no gender!"
    end
  end

  def work
    (defined? self.occupation) ? self.occupation : "no work specified"
  end

  def employer
    (defined? company) ? self.company : "unspecified employer"
  end

  def demographic
    if !(defined? company) || company.nil? || company.length < 1 || company.blank?
      out = "#{self.age.to_s} year old #{sex} #{work} with an unspecified employer"
    else
      out = "#{self.age.to_s} year old #{sex} #{work} at #{employer}"
    end
    return out
  end

  def full_contact(format)
    f = format_hash(format)
    fc = "#{f[:div_start]}#{self.mailingaddress(format)}#{f[:div_end]}"
    fc += "#{f[:div_start]}#{self.primary_phone}#{f[:newline]}"
    fc += "#{self.secondary_phone}#{f[:newline]}" unless secondary_phone.empty?
    fc += self.email_address + f[:div_end]
    fc += "#{f[:div_start]}#{self.demographic}#{f[:div_end]}"
    fc
  end

  def mailingaddress(format = 'html')
    f = format_hash(format)
    ma = "#{self.street_address1}#{f[:newline]}"
    ma += "#{self.street_address2}#{f[:newline]}" unless self.street_address2.empty?
    ma += "#{self.city}, #{self.us_state} #{self.zip}"
    return ma
  end

  def load_health_array
    %w{  history_of_heart_problems
cigarette_cigar_or_pipe_smoking
increased_blood_pressure
increased_total_blood_cholesterol
diabetes_mellitus
heart_problems_chest_pain_or_stroke
breathing_or_lung_problems
muscle_joint_or_back_disorder
hernia
chronic_illness
obesity
recent_surgery
pregnancy
difficulty_with_physical_exercise
advice_from_physician_not_to_exercise  }
  end  

  def find_health_problems
    health_array = load_health_array
    known_health_conditions = []
    no_history = []
    health_array.each do |h|
      if self[h]
        known_health_conditions << h
      else
        no_history << h
      end
    end
    [known_health_conditions, no_history]
  end

  # END FITWIT CUSTOM METHODS

#  def self.find_past(user_id)
    # TODO -- what camps has this user done in the past?
    # TODO -- IT IS AT THE TOP
    # Registration.where
    # this finds past camps for a user -- should be moved to the User object
    # needs to be updated for time_slot relation with registration
    # self.find :all,
    #   :joins => {:time_slots => {:registrations => {:order => :user}}},
    #   :conditions => ['users.id = ? AND fitness_camps.session_start_date <= ?',
    #   user_id,Date.today().to_s(:db)]
#  end

end
