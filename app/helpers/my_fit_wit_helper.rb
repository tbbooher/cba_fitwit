require 'ostruct'

module MyFitWitHelper

  def draw_peer_collection(peers)
    peers.each do |p|
      concat("\t".html_safe + draw_row(p) + "\n".html_safe)
    end
  end

  def draw_row(p)
      if p.user
        content_tag(:tr, class: cycle('light', 'dark')) do
          concat "\t".html_safe + content_tag(:td, p.user.name)
          concat "\t".html_safe + content_tag(:td, p.date_accomplished)
          concat "\t".html_safe + content_tag(:td, p.score)
        end
      end
  end

  def no_zero(in_val)
    in_val == 0 ? "" : in_val
  end

end
