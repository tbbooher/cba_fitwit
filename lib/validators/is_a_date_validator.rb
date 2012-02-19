class IsADateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      unless value.class == DateTime   # then we are good to go
        unless Date.parse(value)
          record.errors[attribute] << (options[:message] || "Invalid date format")
        end
      end
    rescue
      record.errors[attribute] << (options[:message] || "Invalid date format")
    end

  end
end
