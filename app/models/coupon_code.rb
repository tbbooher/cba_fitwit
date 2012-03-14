class CouponCode
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, type: String
  field :price, type: Integer
  field :active, type: Boolean
  field :uses, type: Integer
  field :max_uses, type: Integer
  field :description, type: String
  field :expires_at, type: Date

  has_many :orders

  validates_presence_of   :code, :price
  validates_inclusion_of  :price, in: 0..10000000, message: "must be a valid price"

  def live?
    self.active &&
    !self.expired? &&
    !self.used_up?
  end

  def expired?
    if self.expires_at
      Time.now >= self.expires_at
    end
  end

  def used_up?
    self.uses >= self.max_uses if self.max_uses
  end

end
