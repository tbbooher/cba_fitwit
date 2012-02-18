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

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

end
