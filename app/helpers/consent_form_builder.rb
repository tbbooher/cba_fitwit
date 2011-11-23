
class ConsentFormBuilder < ActionView::Helpers::FormBuilder

  def radio_button(method,
                   tag_value,
                   options = {},
                   checked_values = [])

    if checked_values.map{|my_method, value| method.to_s == my_method && value == tag_value}.any?
      options = options.merge(:checked => true)
    end

    "#{super(method, tag_value, options)} #{tag_value}"
  end

  def text_area(method,
                    tag_value,
                    options = {},
                    button_hash = {})

    tag_id = "#{method}".to_sym

    unless button_hash.empty? || button_hash[tag_id].empty?
      # the actual tag
      style = "display:inline;"
      tag_value = button_hash[tag_id][:tag_content]
      button_hash[tag_id][:explanation_sufficient] ? my_class = "inset" : my_class = "inset more_info_needed"
    else
      style = "display:none;"
    end

    @template.content_tag("div",
                          @template.text_area_tag("health_approval[#{method}_explanation]",
                                tag_value,
                                {:cols => 60,
                                :rows => 1,
                                :class => my_class,
                                :style => style
                                }
                                ), :class => "explanation", :id => "#{method}_explanation"
                          )
  end

end
