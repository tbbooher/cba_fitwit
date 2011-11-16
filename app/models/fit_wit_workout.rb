class FitWitWorkout
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  field :units, :type => String
  field :score_method, :type => String
end
