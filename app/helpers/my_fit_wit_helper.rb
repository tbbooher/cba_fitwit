require 'ostruct'

module MyFitWitHelper

  def draw_peer_collection(peers)
    peers.each do |p|
      concat("\t".html_safe + draw_row(p) + "\n".html_safe)
    end
  end

  def draw_row(p)
      content_tag(:tr, class: cycle('light', 'dark')) do
        concat "\t".html_safe + content_tag(:td, p.user.name)
        concat "\t".html_safe + content_tag(:td, p.date_accomplished)
        concat "\t".html_safe + content_tag(:td, p.score)
      end
  end

  def get_calendar_events(user)
    @fit_wit_workouts = user.exertions.map{|e| OpenStruct.new(:exertion_id => e.id,
                                                               :meeting_date => e.meeting.meeting_date,
                                                               :score => e.score,
                                                               :name => e.exercise.name,
                                                               :format_class => 'fit_wit_workout',
                                                               :previous_scores => "<b>Score:</b> " + e.score + "<br />" + find_previous_scores(@user.id,e.exercise.id,e.exercise.name, e.id)) }
    @custom_workouts = user.custom_workouts.map{|e| OpenStruct.new(:exertion_id => e.exercise_id,
                                                                    :meeting_date => e.workout_date,
                                                                    :score => e.score,
                                                                    :name => e.custom_name.blank? ? Exercise.find(e.exercise_id).name : e.custom_name,
                                                                    :format_class => 'custom_workout',
                                                                    :previous_scores => "<b>Score:</b> " + e.score + "<br />" + e.description) }

    @goals = user.goals.map{|g| OpenStruct.new(:exertion_id => g.id,
                                                :meeting_date => g.target_date,
                                                :score => '',
                                                :name => "Goal: " + g.goal_name,
                                                :format_class => 'goal',
                                                :previous_scores => g.description.empty? ? "no description" : g.description ) }

    @fit_wit_workouts + @custom_workouts + @goals
  end

  def no_zero(in_val)
    in_val == 0 ? "" : in_val
  end

end
