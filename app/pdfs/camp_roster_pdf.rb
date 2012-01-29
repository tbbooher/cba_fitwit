class CampRosterPdf < Prawn::Document

  def initialize(time_slot,campers,view)
    super(page_layout: :landscape, margin: 14)
    @campers = campers
    @view = view
    @time_slot = time_slot
    if @campers.empty?
      text "No campers registered for this camp"
    else
      text @time_slot.longer_title, size: 20, style: :bold
      text "Workout:                                                                Week #: "
      move_down 5
      draw_rows
      number_pages "#{time_slot.short_title} <page> of <total>", {start_count_at: 1, page_filter: :all, at: [bounds.right-250,0], align: :right, size: 14}
    end

  end

  def draw_rows
    table camper_lines, width: 765, header: true do
      row(0).font_style = :bold
      column(0).width = 144
      column(1..4).width = 155.25
      self.row_colors = ["FFFFFF", "DDDDDD"]
    end
  end

  def camper_lines
    [["Camper:", "Contact Name", "Relationship", "Phone", "Health Report"]] +
    @campers.map{|c| [c.full_name, c,"","",""]}
  end

end