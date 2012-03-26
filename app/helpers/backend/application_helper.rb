module Backend::ApplicationHelper
  def odd_or_even
    { class: cycle("odd", "even", name: "rows") }
  end

  def sort_link_to(field)
    params[:order]     ||= "created_at"
    params[:direction] ||= "asc"
    params[:location]  ||= "All"

    b, _b = params[:order].to_s == field.to_s ? ["<b>", "</b>"] : ["",""]
    link_to( (b+"By #{field.to_s.titleize}"+_b+direction_arrow(field)).html_safe,
      backend_users_path(page: params[:page],
        order: field,
        direction: params[:direction] == "asc" ? "desc" : "asc",
        location: params[:location]
      )
    )
  end

  def workouts_in_html(m)
    o = ""
    if m.workouts.size > 0
      m.workouts.group_by{|w| w.fit_wit_workout_id}.each do |fww|
        o += "<h3>" +  FitWitWorkout.find(fww[0]).name + "</h3><br><br>\n"
        o += "<table class=\"table table-striped\">\n"
        o += "<tr><th>name</th><th>score</th><th>rxd</th><th>note</th></tr>\n"
        fww[1].sort_by{|w| w.user.first_name }.each do |wo|
          o += "<div>" + wo.html_output + "</div>\n"
        end
      end
    end
    o
  end

  #def link_to_remove_fields(name, f)
  #  f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  #end

end
