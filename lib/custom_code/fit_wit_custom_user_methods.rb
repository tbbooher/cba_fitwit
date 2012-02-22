module FitWitCustomUserMethods

  # TODO -- include this in a module?
  def camper_since
    self.orders.sort_by { |o| o.created_at }.first.created_at
  end

  def certain_name
    self.last_name.blank? ? self.name : self.full_name
  end

  def find_prs
    self.user_prs
  end

  def find_pr_for(fit_wit_workout)
    self.user_prs.where(fit_wit_workout_id: fit_wit_workout.id).first
  end

  def all_fitness_camps
    unless self.registrations.size == 0
      self.registrations.map &:fitness_camp
    end
    #self.user_time_slots.map{|ts| ts.fitness_camp}.uniq
  end

  def past_fitness_camps
    unless self.registrations.size == 0
      self.registrations.map(&:fitness_camp).select{|c| c.session_end_date <= Date.today}
    end
  end

  def future_fitness_camps
    unless self.registrations.size == 0
      self.registrations.map(&:fitness_camp).select{|c| c.session_start_date >= Date.today}
    end
  end

  def current_fitness_camps
    # it started in the past and still hasn't stopped
    self.registrations.map(&:fitness_camp).select{|c| c.session_start_date >= Date.today && c.session_end_date <= Date.today}
  end

  def user_time_slots
    unless self.registrations.size == 0
      self.registrations.map &:time_slot
    end
    #order_ids = Order.where(user_id: self.id).all.map(&:id)
    #Registration.where(:order_id.in => order_ids).map{|r| r.time_slot}
  end

  def time_slots
    user_time_slots
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def veteran_title
    #  [:veteran, :supervet, :newbie, :staff]
    titles = {:veteran => "veteran", :supervet => "super-vet", :newbie => "first-timer", :staff => "staff"}
    titles[self.veteran_status]
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

  def sex_symbol
    self.gender == :male ? :male : :female
  end

  def sex
    if (defined? self.gender)
      if self.gender == :male
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
      "#{self.age.to_s} year old #{sex} #{work} with an unspecified employer"
    else
      "#{self.age.to_s} year old #{sex} #{work} at #{employer}"
    end
  end

  def full_contact
    fc = self.mailingaddress
    fc += self.primary_phone + "\n"
    fc += self.secondary_phone + "\n" unless self.secondary_phone.empty?
    fc += self.email + "\n"
    fc += self.demographic + "\n"
    fc
  end

  def mailingaddress
    ma = self.street_address1 + "\n"
    ma += self.street_address2 + "\n" unless self.street_address2.nil? || self.street_address2.nil?
    ma += "#{self.city}, #{self.us_state} #{self.zip}\n"
    ma
  end

  def vet_savings
     if self.veteran_status == :veteran
       CartItem::PRICE['traditional']['newbie'] - CartItem::PRICE['traditional']['veteran']
     else
       CartItem::PRICE['traditional']['newbie'] - CartItem::PRICE['traditional']['supervet']
     end
  end

  def user_condition_ids
    self.health_issues.map(&:medical_condition_id)
  end

  def medical_conditions_absent
    issues = []
    MedicalCondition.all.to_a.each do |condition|
      unless self.has_condition?(condition.id)
        issues << condition
      end
    end
    issues
  end

  def has_condition?(mc_id)
    self.user_condition_ids.include?(mc_id)
  end

  def explanation_for(mc_id)
    i = self.health_issues.where(medical_condition_id: mc_id).first
    i.explanation if i
  end

  def health_state
    (self.health_issues.map{|h| "#{h.medical_condition.name}: #{h.explanation}"}.join(",")) + " " +
    (self.has_physician_approval ? "has doctor's approval" : "does not have doctor approval") + " | " +
    (self.meds_affect_vital_signs ? "meds affect vitals" : "meds don't affect vitals") + " | " +
    (self.gender == :female ? "estrogen: #{u.taking_estrogen}, post-menopausal: #{u.post_menopausal_female}" : "")
  end

  def short_health_state
    (self.health_issues.map{|h| h.medical_condition.name }.join(", ")) + " " +
    (self.has_physician_approval ? "" : "| No doc approval!") +
    (self.meds_affect_vital_signs ? "| Meds affect vitals" : "")
    #+
    #(self.gender == :female ? "#{u.taking_estrogen == true ? "| taking estrogen" : ""} #{u.post_menopausal_female == true ? "| post menopausal" : ""}" : "")
  end

  def create_from_cart(cart)
    # creates a pending order
    o = Order.new(user_id: self.id)
    o.amount = cart.total_price(self)
    o.description = self.health_state
    o
  end

  def all_health_issues
      health_issues = []
      MedicalCondition.all.each do |mc|
        if self.health_issues.map(&:medical_condition_id).include?(mc.id)
            hc = self.health_issues.where(medical_condition_id: mc.id).first
            hc.has_it = true
            health_issues << hc
          else
            health_issues << HealthIssue.new(medical_condition_id: mc.id)
        end
      end
      health_issues.sort_by{|hi| hi.medical_condition.name }
  end

end
