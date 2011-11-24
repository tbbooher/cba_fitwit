class CustomWorkout
  include Mongoid::Document
  field :custom_name, :type => String
  field :workout_date, :type => Date
  field :pr, :type => Boolean
  field :description, :type => String
  field :score, :type => String
  field :custom, :type => Boolean
end
