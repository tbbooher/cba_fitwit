class Workout
  include Mongoid::Document
  include Mongoid::Timestamps

  field :score, :type => String
  field :user_note, :type => String
  field :rxd, :type => Boolean
  field :common_value, :type => Float

  validates :score, presence: true, score_has_common_value: true
  validates :fit_wit_workout_id, presence: true


  # relations
  belongs_to :user
  belongs_to :fit_wit_workout
  belongs_to :meeting

  # after save callback
  before_create :find_common_value
  after_save :update_prs

  # this matches find exercise progress

  scope :for_user, ->(user)  { where(user_id: user.id) }
  # we are going to move this to FitnessCamp
  scope :for_camp, ->(camp) { where(:meeting_id.in => camp.time_slots.flatten.map(&:meetings).flatten.map(&:id)) }
  scope :for_fww, ->(fww) { where(fit_wit_workout_id: fww.id )}

  def value
    "#{self.score} #{self.exercise.units}"
  end

  def find_common_value
    if self.fit_wit_workout
      self.common_value = self.fit_wit_workout.common_value(self.score)
    end
  end

  def update_prs
    # if the common_value is better than the users previous value, put this value in
    # and update the global pr table for that workout . . .
    # find user_pr
    #
    # not happy with this -- but will it make life work?
    # We store the pr data in two places and the pr tables grow in each place
    # if they have set a new PR, the user.user_pr table is updated _and_ the fww.prs
    # table is also updated, each fww has an embedded set of prs
    u = self.user
    user_pr = u.find_pr_for(self.fit_wit_workout)
    if user_pr.nil?
      puts "#We have a new PR!"
      new_user_pr = UserPr.new
      new_user_pr.user = u
      update_user_pr_object(new_user_pr, u)
      new_global_pr = Pr.new
      update_global_pr_object(new_global_pr)
    elsif user_pr.common_value < self.common_value
      # should incorporate rxd into this, a non rxd should not replace an rxd
      puts "#We get to replace a PR"
      update_user_pr_object(user_pr, u)
      gpr = self.fit_wit_workout.pr_for(u)
      update_global_pr_object(gpr)
    else
      puts "#No update made"
    end
  end

  def update_global_pr_object(gpr)
    gpr.score = self.score
    gpr.user_note = self.user_note
    gpr.rxd = self.rxd
    gpr.common_value = self.common_value
    gpr.date_accomplished = self.meeting.meeting_date
    gpr.sex = self.user.sex_symbol # :male or :female
    # extra qualifiers for global queries
    gpr.user = self.user
    # all for the love of mongo, our relational database cringes inside
    gpr.fitness_camp = self.meeting.time_slot.fitness_camp
    gpr.time_slot = self.meeting.time_slot
    gpr.meeting = self.meeting
    # embed this in a fww !
    gpr.fit_wit_workout = self.fit_wit_workout
    unless self.fit_wit_workout.save!
      raise "can't save the fww"
    end
  end

  def update_user_pr_object(o_pr, u)
    o_pr.score = self.score
    o_pr.user_note = self.user_note
    o_pr.rxd = self.rxd
    o_pr.common_value = self.common_value
    o_pr.fit_wit_workout = self.fit_wit_workout
    o_pr.fitness_camp = self.meeting.time_slot.fitness_camp
    o_pr.date_accomplished = self.meeting.meeting_date
    unless u.save
      raise "error with pr"
    end
  end
end
