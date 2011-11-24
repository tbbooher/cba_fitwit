class CustomWorkout
  include Mongoid::Document
  include Mongoid::Timestamps

  field :custom_name, type: String
  field :workout_date, type: Date
  field :pr, type: Boolean
  field :description, type: String
  field :score, type: String
  field :custom, type: Boolean

  belongs_to :user
  belongs_to :fit_wit_workout
end
