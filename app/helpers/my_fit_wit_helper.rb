module MyFitWitHelper

  def draw_peer_collection(peers)
    peers.each do |p|
      draw_row(p)
    end
  end

  def draw_row(p)
      content_tag(:tr, class: cycle('light', 'dark')) do
        concat content_tag(:td, p.user.name)
        concat content_tag(:td, p.date_accomplished)
        concat content_tag(:td, p.score)
      end
  end

end
