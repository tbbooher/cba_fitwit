class Registration

  include Mongoid::Document
  include Mongoid::Timestamps

#field :order_id, :type => Integer
#field :created_at, :type => Datetime
#field :updated_at, :type => Datetime
#field :time_slot_id, :type => Integer

  belongs_to :time_slot  # , :null => false
  belongs_to :order
  has_many :friends

  # does this do anything? is this deprecated?
  
#  def self.produce_registration(cart_item)
#    rsg = self.new
#    rsg.time_slot_id = cart_item.fitnesscamp.id
#    rsg.order_id = cart_item.order
#    rsg
#  end

end
