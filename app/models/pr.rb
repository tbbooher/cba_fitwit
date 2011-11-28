class Pr
  include Mongoid::Document
  include Mongoid::Timestamps

  field :score, :type => String
  field :user_note, :type => String
  field :rxd, :type => Boolean
  field :common_value, :type => Float
  field :date_accomplished, type: Date
  field :sex, type: Symbol # :male or :female

  scope :men, where(sex: :male)
  scope :women, where(sex: :female)

  # relations
  embedded_in :fit_wit_workout
#  belongs_to :workout
  belongs_to :user
  belongs_to :fitness_camp
  belongs_to :time_slot
  belongs_to :meeting

  # first we can load this loosely where everyone gets stored under a workout


end

