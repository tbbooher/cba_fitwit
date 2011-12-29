module FitnessCampRegistrationHelper


  def display_chance_to_toggle_session(blnPayBySession,cart_index)
    if blnPayBySession # they are paying by session
      s = 'Naturally, you can still pay for all sessions '
      a = 'Pay for camp'
    else
      s = 'Otherwise, as a vet, you can also pay by session '
      a = 'Pay by session'
    end
    out = '<div>'
    out += s
    out += submit_tag(a,
                      :name => "pay_by_session[#{cart_index}]",
                      :class => 'button')
    out += '</div>'
  end



end
