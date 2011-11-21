class Meeting

  include Mongoid::Document
  include Mongoid::Timestamps

  field :meeting_date, type: Date

  belongs_to :time_slot
  references_many :attendees, class_name: "User", inverse_of: :attendances
  # need to get workouts in here
  
  def meeting_date_f
    self.meeting_date.strftime("%d-%b")
  end
  
  def self.get_existing_attendee_ids(meeting_id)
    self.find(meeting_id).meeting_users.map{|mu| mu.user_id}
  end
  
  def self.find_by_loc_and_range(location_id,beginning_of_period,end_of_period)
     self.find(:all, :joins => {:time_slot => {:fitness_camp => :location}},
      :conditions => ["(meeting_date >= ? and meeting_date <= ?) and location_id = ?",
        beginning_of_period,end_of_period,location_id])
  end
  
  def all_exercises
    Exercise.find(:all, :joins => {:exertions => :meeting_user},
      :conditions => ["meeting_id = ?", self.id]).uniq
  end
  
  def build_labels(names)
    i = -1
    names.collect! {|x| i += 1; [i,x]}.inject({}) {|ha, (k,v)| ha[k] = v; ha}
  end

  def attended?(user_id)
    self.users.map{|user| user.id }.include?(user_id)
  end

end
