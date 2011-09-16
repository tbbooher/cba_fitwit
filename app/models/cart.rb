class Cart
# not a mongoid document

  attr_reader :items
  attr_accessor :new_membership
  attr_accessor :coupon_code

  def initialize
    @items = []
    @new_membership = false
  end

  def add_timeslot(timeslot)
    current_item = @items.find {|item| item.timeslot == timeslot}
    if current_item # do nothing
      # TODO THIS REALLY NEEDS FIXED!
      # don't need increment_quantity -- should do error here
      #current_item.increment_quantity
    else
      # hide the button
      current_item = CartItem.new(timeslot)
      @items << current_item
    end
    current_item
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
