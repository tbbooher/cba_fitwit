class CampWorkout
  include Mongoid::Document

  belongs_to :meeting
  has_many :workouts, autosave: true
  belongs_to :fit_wit_workout

  accepts_nested_attributes_for :workouts, reject_if: lambda {|a| a[:score].blank? }, allow_destroy: true

end
