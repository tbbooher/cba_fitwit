class TaggedBuilder < ActionView::Helpers::FormBuilder

  # check_box(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
  def check_box(method,
      options,
      checked_value,
      unchecked_value,
      names_of_titles_that_require_more_information)
    # check_box(object_name, method, options = {}, checked_value =
    # "1", unchecked_value = "0") public

    # read in prompt
    #names_of_titles_that_require_more_information = args.last.is_a?(Array) ? args.pop : []
    #    methods = names_of_titles_that_require_more_information[:condition] || []

    text_area_id = "#{method}_explanation"

    #options = options.merge(:onclick => "$('#{text_area_id}').toggle()")

    #RAILS_DEFAULT_LOGGER.info(options.inspect.to_yaml)

    output = @template.content_tag(:div,
      "#{super(method, options, checked_value, unchecked_value)} " +
      "#{method.to_s.humanize}<br />", :class => "checkbox")

    # style=\"vertical-align: middle; height:20px; background-color:red; display:inline;\"
    #    if names_of_titles_that_require_more_information.include?(method.to_s)
    #       output = determine_options(output, method)
    #    end

    need_more_info = names_of_titles_that_require_more_information.include?(method.to_s)

    condition_value = object[method]

    output = determine_options(output, method, condition_value, need_more_info,text_area_id)

    return output
  end

  def determine_options(output,
                        method,
                        condition_value,
                        need_more_info,
                        text_area_id)

    explanation = object["#{method}_explanation"]

    if explanation
      if need_more_info || (!explanation.empty? && explanation != "Please explain")
        display_value = "display:block;"
      else
        display_value = "display:none;"
      end
    end

    unless condition_value # then we want to de-emphasize
      text_area_class = "inset deemphasized "
    else
      text_area_class = "inset "
    end

    text_area_class += "more_info_needed" if need_more_info

    output += "\n"
    output += @template.content_tag("div id=\"#{text_area_id}\" " +
                                    "class=\"explanation\" style=\"#{display_value}\"",
      self.text_area(text_area_id,
        :cols => 60,
        :rows => 1,
        :class => text_area_class) + "Please explain")
  end



end
