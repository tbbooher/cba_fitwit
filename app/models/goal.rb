class Goal
  include Mongoid::Document
  field :goal_name, :type => String
  field :description, :type => String
  field :date_added, :type => Date
  field :target_date, :type => Date
  field :completed, :type => Boolean
  field :completed_date, :type => Date
end
