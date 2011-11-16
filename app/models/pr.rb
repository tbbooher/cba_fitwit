class Pr
  include Mongoid::Document
  field :score, :type => String
  field :user_note, :type => String
  field :rxd, :type => Boolean
  field :common_value, :type => Float
end
