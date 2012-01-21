require 'digest/sha1'

class CartItem

#  has_many :friends
  attr_reader :time_slot_id, :unique_id
  attr_accessor :friends, :payment_arrangement, :number_of_sessions, :camp_price, :coupon_discount, :coupon_code_id

  # PRICE = YAML.load_file("#{Rails.root}/config/prices.yml")

  def display_friends
    self.friends.each do |f|
      f.name
    end # friends
  end
  
  def initialize(time_slot_id)
    @time_slot_id = time_slot_id
    @camp_price = 0.to_f
    @friends = []
    @payment_arrangement = :traditional
    @coupon_discount = 0
    @coupon_code = 'no coupon'
    @number_of_sessions = 0
    @unique_id = Digest::SHA1.hexdigest Time.now.to_s
  end

  def time_slot
    TimeSlot.find(@time_slot_id)
  end
  
  def bring_a_friend(friend_name)
    @friends.push(friend_name)
  end
  
  def delete_a_friend(friend_index)
    @friends.delete_at(friend_index)
  end

  def title
    TimeSlot.find(self.time_slot_id).short_title
  end
  
  def title_with_camp_dates
    time_slot = TimeSlot.find(self.time_slot_id)
    "#{time_slot.short_title} from #{time_slot.fitness_camp.stdt} to #{time_slot.fitness_camp.eddt}"
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
            self.coupon_discount/100)*100
    end
  end

  def show_payment_method_text
    # End this sentence :
    # You are currently . . .
    case self.payment_arrangement
      when :initial_member
        "starting a new membership"
      when :member
        "on an active membership"
      when :staff
        "a staff member"
      when :pay_by_session
        "paying by session"
      else
        "paying using traditional method"
    end
  end

  private

  def session_payment(num_sessions)
    PRICE['pay_by_session'][num_sessions.to_i]
  end

end
