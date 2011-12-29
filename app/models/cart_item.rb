class CartItem

#  has_many :friends
  attr_reader :timeslot
  attr_accessor :friends, :payment_arrangement, :number_of_sessions, :camp_price, :coupon_discount

  PRICE = YAML.load_file("#{Rails.root}/config/prices.yml")

  def display_friends
    self.friends.each do |f|
      f.name
    end # friends
  end
  
  def initialize(timeslot)
    @timeslot = timeslot
    @camp_price = 359.to_f
    @friends = []
    @payment_arrangement= nil
    @coupon_discount = 0
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

  def title
    @timeslot.short_title
  end
  
  def title_with_camp_dates
    "#{@timeslot.short_title} from #{@timeslot.fitness_camp.stdt} to #{@timeslot.fitness_camp.eddt}"
  end

  def friend_count
    [PRICE['friend_discount']['max_vet_friends'], self.friends.size].min
  end

  def camp_price(user)
    case self.payment_arrangement
      when :pay_by_session # depends on the number of sessions
        session_payment(self.number_of_sessions)*100
      when :initial_member
        (PRICE['monthly_membership_fee'] + PRICE['setup_fee'])*100
      when [:member, :staff] # payment is made elsewhere
        0
      else # traditional
        vs = user.veteran_status.to_s
        (PRICE['traditional'][vs] -
            PRICE['friend_discount'][vs]*self.friend_count -
            self.coupon_discount)*100
    end
  end

  private

  def session_payment(num_sessions)
    PRICE['pay_by_session'][num_sessions]
  end

end
