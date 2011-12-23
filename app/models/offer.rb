class Offer
  include Mongoid::Document
  field :content # , type: String
  field :active, type: Boolean
end
