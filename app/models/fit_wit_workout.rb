require 'googlecharts'

class FitWitWorkout
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  field :units, :type => String
  field :score_method, :type => String, default: "simple-rounds"

  # relations
  has_many :workouts
  embeds_many :prs

  # methods

  EXERCISE_UNITS = [
          #  Displayed        stored in db
  ["Repetitions", "repetitions"],
  ["Rounds", "rounds"],
  ["Time", "seconds"]
  ]

  SCORE_METHODS = [
          #  Displayed        stored in db
  ["Sum Slashes", "sum-slashes"],
  ["Sum Commas", "sum-commas"],
  ["Rounds", "simple-rounds"],
  ["Time", "simple-time"],
  ["Parse Time", "parse-time"],
  ["Slash-separated Time", "slash-separated-time"],
  ]

  def pr_for(user)
    self.prs.where(user_id: user.id).first
  end

  def top_10_all_fit_wit
    self.prs.desc(:common_value).limit(10)
  end

  def top_10_all_fit_wit_by_gender(sex)
    self.prs.where(sex: sex).desc(:common_value).limit(10).all.to_a
  end

  # this is used in the admin controller for calendar_progress
  def find_completed_fit_wit_workouts
    Workout.where(fit_wit_workout_id: self.id).all.to_a
  end

  # these exist only to help with the input process


  #def find_10_scores
  #  # used in exercises_controller (as example)
  #  Exertion.all(:select => 'score', :conditions => ['fit_wit_workout_id = ?', self.id], :limit => 10, :order => 'created_at DESC').map { |e| e.score }
  #end

  #def find_10_common_scores
  #  # used in the exercise controller
  #  #we want to modify this or create errors
  #  output = []
  #  errors = 0
  #  Exertion.all(:conditions => ['fit_wit_workout_id = ?', self.id], :limit => 400, :order => 'created_at DESC').each do |exertion|
  #    begin
  #      output.push([exertion.user.short_name, exertion.score, common_value(exertion.score)])
  #    rescue Exception=>e
  #      errors+=1
  #      output.push([exertion.user.short_name, exertion.score, "<b style=\"color:red;\">error!!</b>"])
  #    end
  #  end
  #  return output, errors
  #
  #end

  def find_average(sex)
    common_values = self.prs.where(sex: sex).map(&:common_value)
    #cvs = self.exertions.select { |exu| exu.user.gender == gender_id }.map { |ex| ex.common_value }
    common_values.size > 0 ? common_values.sum / common_values.size : nil
  end

  # used to build chart ... important
  # we want the best score for the gender
  def find_best(sex)
    #prs = self.prs.where(sex: sex)
    self.prs.where(sex: sex).to_a.max{|pr| pr.common_value}.common_value
    #prs.empty? ? nil : prs.max(:common_value)
    #self.exertions.select { |exu| exu.user.gender == gender_id }.map { |ex| ex.common_value }.max
  end

  #def find_leaders(the_gender)
  #  if self.score_method.nil?
  #    return false
  #  else
  #    return Exertion.find_by_sql("SELECT * from prs WHERE (fit_wit_workout_id = #{self.id} AND gender = #{the_gender}) ORDER BY common_value DESC LIMIT 10;")
  #  end
  #end

  def find_competition(user)
    # given a user's pr for this workout -- who are his competitors?
    pr = self.pr_for(user)
    the_score = pr.common_value
    sex = user.sex_symbol
    five_above = self.prs.where(:common_value.gte => the_score).
        and(sex: sex).excludes(user_id: user.id).asc(:common_value).limit(5).to_a
    five_below = self.prs.where(:common_value.lt => the_score).
        and(sex: sex).excludes(user_id: user.id).desc(:common_value).limit(5).to_a
    # the following are collections of prs
    {above: five_above.reverse, below: five_below, me: pr}
  end

  def find_peers(exertions_for_fit_wit_workout)
    # find peers to the max of a given list of exertions
    max_exertion = exertions_for_fit_wit_workout.first # we have ordered it this way! #map{|exertion| [exertion.id, exertion.common_value]}.max_by{|u,v| v}
    ex_id = max_exertion.fit_wit_workout.id
    the_score = max_exertion.common_value
    five_above = Exertion.find_by_sql("select * from prs where fit_wit_workout_id = #{ex_id} and common_value > #{the_score} ORDER BY common_value ASC limit 5;")
    five_below = Exertion.find_by_sql("select * from prs where fit_wit_workout_id = #{ex_id} and common_value < #{the_score} ORDER BY common_value DESC limit 5;")
    #xs = self.exertions.map{|ex| [ex, ex.common_value]}.sort_by{|ex,common_value| common_value}.reverse
    #idx = exs.index{|e,s| e.id == max_score.first}
    # need to put user in there
    return five_above.reverse + five_below
  end

  def done_at_meeting(meeting_id)
    Exertion.find(:all, :joins => :meeting_user,
                  :conditions => ["meeting_id = ? AND fit_wit_workout_id = ?", meeting_id, self.id])
  end

  def placement_at_meeting(meeting_id)
    Exertion.find(:all, :joins => :meeting_user,
                  :conditions => ["meeting_id = ? AND fit_wit_workout_id = ?", meeting_id, self.id],
                  :order => 'score DESC')
  end

  def common_value(score)
    #complicated function -- all times are inverted so the highest score wins!
    case self.score_method
      when "sum-slashes"
        my_common_value = score.split("/").collect { |a| a.to_f }.sum
      when "sum-commas"
        my_common_value = score.split(",").collect { |a| a.to_f }.sum
      when "simple-rounds"
        my_common_value = score.to_f
      when "simple-time"
        my_common_value = get_time(score)
      when "parse-time"
        my_common_value = 60000/(Time.parse(score).to_f- Time.parse('0:00').to_f) # 10 minutes => 100, 1 minute => 1000, 1 sec = 60000
      when "slash-separated-time"
        my_common_value = (score.split("/").collect { |a| get_time(a) }.sum)
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

  def get_progress_chart(user, workouts)
    # TODO -- i think we should put this in a model . . .
    is_time = !(self.score_method =~ /time/).nil?
    gender = user.sex_symbol
    common_inputs = workouts.map { |e| e.common_value }
    common_vals = is_time ? common_inputs.delete_if { |e| e == 0 }.map { |cv| 1/cv } : common_inputs
    average = is_time ? 1/self.find_average(gender) : self.find_average(gender)
    best = is_time ? 1/self.find_best(gender) : self.find_best(gender)
    scale_factor = 80/([best] + [average] + common_vals).max # google charts have a max of 100
    scores = self.score_method.nil? ? '' : common_vals.map { |c| c*scale_factor }
    dates = self.score_method.nil? ? nil : workouts.map { |e| e.meeting.meeting_date }
    # build chart
    chart_width = 400
    progress_chart = Gchart.line(
      title: "#{user.full_name}'s progress for #{self.name}",
      height: 200,
      width: chart_width,
      data: scores,
      encoding: 'text',
      colors: '000000',
      show_labels: true,
      labels: dates
    )
    annotations = ''
    workouts.each_with_index do |e, index|
      score = e.score.gsub(",", "+").gsub("/", "+")
      annotations+="|A#{score},666666,0,#{index},15"
    end
    misc = "&chxt=x,r&chxl=1:|best|average&chxp=1,#{best*scale_factor},#{average*scale_factor}&chxs=1,0000dd,13,-1,t,FF0000&chxtc=1,-#{chart_width}"
    fills = "&chm=o,393939,0,-1,10.0#{annotations}"
    #        fills: 'B,cccccc,0,0,0|o,393939,0,-1,10.0' + annotations # filled, marker,
    progress_chart + misc + fills
  end

  def javascript_chart_data(user, workouts)
    # this is if we want to do a javascript chart . . .
    # let's get ready
    is_time = (self.units == "seconds")
    gender = user.sex_symbol
    # now let's build our data
    common_inputs = workouts.map { |e| e.common_value }
    common_vals = is_time ? common_inputs.delete_if { |e| e == 0 }.map { |cv| 1/cv } : common_inputs
    average = is_time ? 1/self.find_average(gender) : self.find_average(gender)
    best = is_time ? 1/self.find_best(gender) : self.find_best(gender)
    scale_factor = 80/([best] + [average] + common_vals).max # google charts have a max of 100
    scores = self.score_method.nil? ? '' : common_vals.map { |c| c*scale_factor }
    dates = self.score_method.nil? ? nil : workouts.map { |e| e.meeting.meeting_date }
    # chart specifics
    {scores: scores, dates: dates}
  end


  private

  def get_time(my_time)
    begin
      time_array = my_time.split(":").map { |x| x.to_f }
      case time_array.length
        when 1 # assume seconds
          my_common_value = (time_array/60)
        when 2 # assume minutes:seconds
          my_common_value = (time_array[0] + time_array[1]/60) # in minutes
        when 3 # assume hours (? gasp), minutes, seconds
          my_common_value = (time_array[0]*60 + time_array[1] + time_array[2]/60) # in minutes
        else
          my_common_value = 0 #"#error" # raise exception
          raise "time error"
      end
    rescue
      my_common_value = 0 #'#error'
    end
    return 1000/my_common_value
  end



end
