class Offer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content # , type: String
  field :active, type: Boolean

end
