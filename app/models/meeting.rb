class Meeting

  include Mongoid::Document
  include Mongoid::Timestamps

  field :meeting_date, type: Date

  belongs_to :time_slot
  has_and_belongs_to_many :attendees, class_name: "User", inverse_of: :attendances
  has_many :workouts
  # need to get workouts in here
  
  def meeting_date_f
    self.meeting_date.strftime("%d-%b")
  end
  
  # TODO -- needed in attendance_controller -- but i think this is habtm checkboxes
  # commenting out
  #def self.get_existing_attendee_ids(meeting_id)
  #  self.find(meeting_id).meeting_users.map{|mu| mu.user_id}
  #end
  
  # no insight into why I need this?
  # find_by_location_and_range is commented out in location_info_controller
  # def self.find_by_loc_and_range(location_id,beginning_of_period,end_of_period)
  #    self.find(:all, :joins => {:time_slot => {:fitness_camp => :location}},
  #     :conditions => ["(meeting_date >= ? and meeting_date <= ?) and location_id = ?",
  #       beginning_of_period,end_of_period,location_id])
  # end
  
  # recommend moving out -- this is just a property of the association
  # def all_fit_wit_workouts
  #   Exercise.find(:all, :joins => {:exertions => :meeting_user},
  #     :conditions => ["meeting_id = ?", self.id]).uniq
  # end

  # HOW THE HECK DID I WRITE THIS? (and why did I write this?)
  # def build_labels(names)
  #   i = -1
  #   names.collect! {|x| i += 1; [i,x]}.inject({}) {|ha, (k,v)| ha[k] = v; ha}
  # end

  # we want to know if a user attended this class . . .
  def attended?(user)
    self.attendees.include?(user)
    # self.users.map{|user| user.id }.include?(user_id)
  end

end
