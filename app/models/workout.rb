class Workout
  include Mongoid::Document
  include Mongoid::Timestamps

  field :score, :type => String
  field :user_note, :type => String
  field :rxd, :type => Boolean
  field :common_value, :type => Float

  # relations
  belongs_to :user
  belongs_to :meeting
  belongs_to :fit_wit_workout

end
