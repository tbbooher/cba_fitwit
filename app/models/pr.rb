class Pr
  include Mongoid::Document
  include Mongoid::Timestamps

  field :score, :type => String
  field :user_note, :type => String
  field :rxd, :type => Boolean
  field :common_value, :type => Float

  # relations
  embedded_in :user
  belongs_to :workout
  belongs_to :fit_wit_workout

end

