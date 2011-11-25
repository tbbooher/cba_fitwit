class Measurement
  include Mongoid::Document
  field :review_date, :type => Date
  field :height, :type => Float
  field :weight, :type => Float
  field :chest, :type => Float
  field :waist, :type => Float
  field :hip, :type => Float
  field :right_arm, :type => Float
  field :right_thigh, :type => Float
  field :bmi, :type => Float
  field :bodyfat_percentage, :type => Integer

  embedded_in :user
end
