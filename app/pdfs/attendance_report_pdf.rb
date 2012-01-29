class AttendanceReportPdf < Prawn::Document

  def initialize(time_slot,campers,view)
    super(page_layout: :landscape, margin: 14)
    @campers = campers
    @view = view
    @time_slot = time_slot
    draw_head
    draw_rows
  end

  def draw_head
    text @time_slot.short_title, size: 20, style: :bold
  end

  def draw_rows
    table camper_lines, width: 765 do
      style(row(1), background_color: 'ff00ff')
      column(0).width = 144
      column(1..4).width = 155.25
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def camper_lines
    [["Name", "", "", "", ""]] +
    [["Week #", "", "", "", ""]] +
    [["Day of the Week", "", "", "", ""]] +
    [["Date", "", "", "", ""]] +
    [["Workout", "", "", "", ""]] +
    @campers.map{|c| [c.full_name, "","","",""]}
  end

end