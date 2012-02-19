class ScoreHasCommonValueValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    #record.errors[attribute] << (options[:message] || "Score not in correct format")
    begin
      common_value = record.fit_wit_workout.common_value(record.score)

      time = /[\d\.]+(?:\:[\d\.]+){,2}/
      float = /\d+(?:\.\d+)?/
      error = false
      case record.fit_wit_workout.score_method
        when "sum-slashes"
          error = true unless record.score.match(/\A#{float}+(?:\/#{float}+)*\z/)
        when "sum-commas"
          error = true unless record.score.match(/\A#{float}+(?:,#{float}+)*\z/)
        when "simple-rounds"
          error = true unless record.score.match(/\A\d+\z/)
        when "simple-time", "parse-time"
          error = true unless record.score.match(/\A#{time}\z/)
        when "slash-separated-time"
          error = true unless record.score.match(/\A#{time}+(?:\/#{time}+)*\z/)
        else
          error = true
      end
      if error
        record.errors[attribute] << (options[:message] || "Incorrect format for #{record.fit_wit_workout.name} (#{record.fit_wit_workout.score_method})")
      end

    rescue
      record.errors[attribute] << (options[:message] || "Score not in correct format")
    end
  end
end
