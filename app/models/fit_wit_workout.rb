class FitWitWorkout
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  field :units, :type => String
  field :score_method, :type => String

  # relations
  has_many :workouts

  # methods

  EXERCISE_UNITS = [
          #  Displayed        stored in db
  ["Repetitions", "repetitions"],
  ["Rounds", "rounds"],
  ["Time", "seconds"]
  ]

  SCORE_METHODS = [
          #  Displayed        stored in db
  ["Sum Dashes", "sum-dashes"],
  ["Sum Commas", "sum-commas"],
  ["Rounds", "simple-rounds"],
  ["Time", "simple-time"],
  ["Parse Time", "parse-time"],
  ["Slash-separated Time", "slash-separated-time"],
  ]

  def find_completed_exercises
    Exertion.find(:all, :conditions => ["exercise_id = ?", self.id])
  end

  def find_10_scores
    Exertion.all(:select => 'score', :conditions => ['exercise_id = ?', self.id], :limit => 10, :order => 'created_at DESC').map { |e| e.score }
  end

  def find_10_common_scores
    #we want to modify this or create errors
    output = []
    errors = 0
    Exertion.all(:conditions => ['exercise_id = ?', self.id], :limit => 400, :order => 'created_at DESC').each do |exertion|
      begin
        output.push([exertion.user.short_name, exertion.score, common_value(exertion.score)])
      rescue Exception=>e
        errors+=1
        output.push([exertion.user.short_name, exertion.score, "<b style=\"color:red;\">error!!</b>"])
      end
    end
    return output, errors
  end

  def find_average(gender_id)
    cvs = self.exertions.select { |exu| exu.user.gender == gender_id }.map { |ex| ex.common_value }
    return cvs.sum / cvs.size
  end

  def find_best(gender_id)
    self.exertions.select { |exu| exu.user.gender == gender_id }.map { |ex| ex.common_value }.max
  end

  def find_leaders(the_gender)
    if self.score_method.nil?
      return false
    else
      return Exertion.find_by_sql("SELECT * from prs WHERE (exercise_id = #{self.id} AND gender = #{the_gender}) ORDER BY common_value DESC LIMIT 10;")
    end
  end

  def find_peers(exertions_for_exercise)
    # find peers to the max of a given list of exertions
    max_exertion = exertions_for_exercise.first # we have ordered it this way! #map{|exertion| [exertion.id, exertion.common_value]}.max_by{|u,v| v}
    ex_id = max_exertion.exercise.id
    the_score = max_exertion.common_value
    five_above = Exertion.find_by_sql("select * from prs where exercise_id = #{ex_id} and common_value > #{the_score} ORDER BY common_value ASC limit 5;")
    five_below = Exertion.find_by_sql("select * from prs where exercise_id = #{ex_id} and common_value < #{the_score} ORDER BY common_value DESC limit 5;")
    #xs = self.exertions.map{|ex| [ex, ex.common_value]}.sort_by{|ex,common_value| common_value}.reverse
    #idx = exs.index{|e,s| e.id == max_score.first}
    # need to put user in there
    return five_above.reverse + five_below
  end

  def done_at_meeting(meeting_id)
    Exertion.find(:all, :joins => :meeting_user,
                  :conditions => ["meeting_id = ? AND exercise_id = ?", meeting_id, self.id])
  end

  def placement_at_meeting(meeting_id)
    Exertion.find(:all, :joins => :meeting_user,
                  :conditions => ["meeting_id = ? AND exercise_id = ?", meeting_id, self.id],
                  :order => 'score DESC')
  end

  def common_value(score)
    #complicated function -- all times are inverted so the highest score wins!
    case self.score_method
      when "sum-dashes"
        my_common_value = score.split("/").collect { |a| a.to_f }.sum
      when "sum-commas"
        my_common_value = score.split(",").collect { |a| a.to_f }.sum
      when "simple-rounds"
        my_common_value = score.to_f
      when "simple-time"
        my_common_value = get_time(score)
      when "parse-time"
        my_common_value = 1/(Time.parse(score).to_f- Time.parse('0:00').to_f) # in seconds
      when "slash-separated-time"
        my_common_value = 1/(score.split("/").collect { |a| get_time(a) }.sum)
      when "Rodeo (squat jumps, bronco burpees, 8-count burpees)"
        time_array = score.split(":").map { |x| x.to_f }
        case time_array.length
          when 1
            my_common_value = time_array/60
          when 2
            my_common_value = time_array[0] + time_array[1]/60 # in minutes
          when 3
            my_common_value = time_array[0]*60 + time_array[1] + time_array[2]/60 # in minutes
        end
      else
        my_common_value = 'no score method defined' # self.score.to_f
    end
    begin
      return my_common_value.to_f
    rescue  Exception => e
      puts e.message
      puts e.backtrace.inspect  
      return 0
    end
  end

  private

  def get_time(my_time)
    begin
      time_array = my_time.split(":").map { |x| x.to_f }
      case time_array.length
        when 1 # assume seconds
          my_common_value = 1/(time_array/60)
        when 2 # assume minutes:seconds
          my_common_value = 1/(time_array[0] + time_array[1]/60) # in minutes
        when 3 # assume hours (? gasp), minutes, seconds
          my_common_value = 1/(time_array[0]*60 + time_array[1] + time_array[2]/60) # in minutes
        else
          my_common_value = 0 #"#error" # raise exception
          raise "time error"
      end
    rescue
      my_common_value = 0 #'#error'
    end
    return my_common_value
  end



end
