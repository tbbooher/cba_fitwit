class UserPr
  include Mongoid::Document
  include Mongoid::Timestamps

  field :score, :type => String
  field :user_note, :type => String
  field :rxd, :type => Boolean
  field :common_value, :type => Float
  field :date_accomplished, type: Date

  # relations
  embedded_in :user
#  belongs_to :workout
  belongs_to :fit_wit_workout
  belongs_to :fitness_camp

  # first we can load this loosely where everyone gets stored under a workout

  # here we need a method to make sure each pr is uniq

end
