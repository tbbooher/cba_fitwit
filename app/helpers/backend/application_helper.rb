module Backend::ApplicationHelper
  def odd_or_even
    { class: cycle("odd", "even", name: "rows") }
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end
end
