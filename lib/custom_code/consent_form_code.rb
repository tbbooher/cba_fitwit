module ConsentFormCode

  def verify_user_is_healthy(user)
    render partial: 'fitness_camp_registration/consent_forms/user_verification', locals: {user: user}
  end

  def show_medical_conditions(user)
    render partial: 'fitness_camp_registration/consent_forms/medical_condition', :collection => MedicalCondition.all
  end

  def show_health_problems(user)
    if user.health_issues.size == 0
       "You have not reported any previous medical conditions." +
       " Are you sure you have never had any of the following conditions?" +
       " If this is incorrect, you can update your health history"
    else
      list = user.health_issues.map {|issue| content_tag(:li, issue.medical_condition.name)}.join("\n").html_safe
      content_tag(:h4, "You reported a history of:") + content_tag(:ul, list, class: 'img-list ico-checkmark')
    end
  end

  def show_clear_health(user)
    content_tag :ul, class: 'img-list ico-checkmark' do
     user.medical_conditions_absent.map{|mc| content_tag(:li, mc.name)}.join("\n").html_safe
    end
  end

end