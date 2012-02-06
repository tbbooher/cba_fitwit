class OfFitnessCampLocationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.time_slot
      unless record.time_slot.fitness_camp.location_id.to_s == record.user.location_id.to_s
        record.errors[attribute] << (options[:message] || "A user and time slot must share the same location")
      end
    end
    #if record.time_slot.fitness_camp.time_slots.map{|ts| ts.registrations}.flatten.map(&:user_id).include?(record.user.id)
    #  record.errors[attribute] <<  (options[:message] || "A user can only register for one time_slot in a camp")
    #end
  end
end
