class CampRosterPdf < Prawn::Document

  def initialize(time_slot,campers,view)
    super(page_layout: :landscape, margin: 30)
    @campers = campers
    @view = view
    @time_slot = time_slot
    if @campers.empty?
      text "No campers registered for this camp"
    else
      text "Contact Roster for " + @time_slot.longer_title, size: 15, style: :bold
      move_down 5
      draw_rows
      number_pages "Contact Roster for #{time_slot.short_title} | Page <page> of <total>", {start_count_at: 1, page_filter: :all, at: [bounds.right-730,0], align: :left, size: 14}
    end

  end

  def draw_rows
    table camper_lines, width: 765, header: true do
      row(0).font_style = :bold
      column(0).width = 80
      column(1).width = 100
      column(2).width = 60
      column(3..5).width = 100
      column(6).width = 125
      column(7).width = 100
      self.row_colors = ["FFFFFF", "DDDDDD"]
    end
  end

  def camper_lines
    [["Camper", "Contact Name", "Emergency Phone", "Relationship", "Phone", "Health Report", "Email", "Address"]] +
    @campers.map do |c|
      [c.full_name, c.emergency_contact_name, c.emergency_contact_phone, c.emergency_contact_relationship, c.primary_phone, c.short_health_state,
      c.email, c.one_line_address]
    end
  end

end