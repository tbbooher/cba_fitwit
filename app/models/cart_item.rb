class CartItem

#  has_many :friends
  attr_reader :timeslot
  attr_accessor :friends, :pay_by_session, :number_of_sessions, :price
  
  def display_friends
    self.friends.each do |f|
      f.name
    end # friends
  end
  
  def initialize(timeslot)
    @timeslot = timeslot
#    @name_of_friend = nil
#    @discount_category = 0.to_i
    @price = 359.to_f
    @friends = []
    @pay_by_session = nil
    @number_of_sessions = 0
#    @new_membership = false
    #    @quantity = 1
  end
  
  def bring_a_friend(friend_name)
    @friends.push(friend_name)
  end
  
  def delete_a_friend(friend_index)
    @friends.delete_at(friend_index)
  end
  #  def increment_quantity
  #    @quantity += 1
  #  end

  def title
    @timeslot.short_title
  end
  
  def title_with_camp_dates
    out = "#{@timeslot.short_title} from #{@timeslot.fitness_camp.stdt} "
    out += "to #{@timeslot.fitness_camp.eddt}"
  end

end
