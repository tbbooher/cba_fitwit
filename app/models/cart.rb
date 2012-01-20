class Cart
# not a mongoid document

  attr_reader :items
  attr_accessor :new_membership
  attr_accessor :coupon_code
  attr_accessor :consent_updated

  def initialize
    @items = []
    @new_membership = false
    @consent_updated = false
  end

  def add_timeslot(time_slot_id)
    item = @items.select {|i| i.time_slot_id == time_slot_id}
    if item.empty? # @items.map(&:time_slot_id).include?(time_slot_id)
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

  def total_price
#    self.total_items*myprice
    if self.coupon_code
      self.coupon_code.price
    else
      @items.sum {|item| item.price}
    end
  end

end
