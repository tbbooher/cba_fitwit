class CustomWorkout
  include Mongoid::Document
  include Mongoid::Timestamps

  field :custom_name, type: String
  field :workout_date, type: Date
  field :pr, type: Boolean
  field :description, type: String
  field :score, type: String
  field :custom, type: Boolean, default: true # if this is true, this a custom user's workout

  belongs_to :user
  belongs_to :fit_wit_workout

  def title
    # there is no custom name or id is 0
    if self.custom # self.custom_name.blank? || self.fit_wit_workout_id == 0
       self.custom_name.blank? ? "Personal Workout" : self.custom_name
    else
      self.fit_wit_workout.name
    end
  end


end
