class CampRosterPdf < Prawn::Document

  def initialize(time_slot,campers,view)
    super(page_layout: :landscape, margin: 30)
    @campers = campers
    @view = view
    @time_slot = time_slot
    if @campers.empty?
      text "No campers registered for this camp"
    else
      text "Contact Roster for " + @time_slot.longer_title, size: 20, style: :bold
      move_down 5
      draw_rows
      number_pages "Contact Roster for #{time_slot.short_title} | Page <page> of <total>", {start_count_at: 1, page_filter: :all, at: [bounds.right-730,0], align: :left, size: 14}
    end

  end

  def draw_rows
    table camper_lines, width: 765, header: true do
      row(0).font_style = :bold
      column(0).width = 144
      column(1..3).width = 107
      column(4).width = 300
      self.row_colors = ["FFFFFF", "DDDDDD"]
    end
  end

  def camper_lines
    [["Camper", "Contact Name", "Relationship", "Phone", "Health Report"]] +
    @campers.map do |c|
      [c.full_name, c.emergency_contact_name, c.emergency_contact_relationship, c.primary_phone, c.short_health_state]
    end
  end

end