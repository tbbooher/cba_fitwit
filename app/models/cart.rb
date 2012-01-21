class Cart
# not a mongoid document

  attr_reader :items
  attr_accessor :new_membership
  attr_accessor :consent_updated

  def initialize
    @items = []
    @new_membership = false
    @consent_updated = false
    @membership_price = 0 # in cents
    @membership_setup = 0
  end

  # maybe delete
  def add_timeslot(time_slot_id)
    item = @items.select {|i| i.time_slot_id == time_slot_id}
    if item.empty?
      item = CartItem.new(time_slot_id)
      @items << item
    end
    item
  end
  
#  def add_discount_data(my_id, discount_category, name_of_friend, price)
#    CartItem.find(my_id)
#    myitem.add_discount_data(name_of_friend, discount_category, price)
#  end

  def in_cart?(item_id)
    @items.map{|i| i.timeslot.id == item_id}.include?(true)
  end

  def total_items
    @items.length
    #@items.sum {|item| item.quantity}
  end

  def total_price(user)
    if self.new_membership
       @membership_price +  @membership_setup
    else
      @items.sum { |item| item.camp_price(user) }
    end
  end

end
