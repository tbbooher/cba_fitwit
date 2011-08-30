class NewsItem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :item_text, :type => String
  field :display, :type => Boolean

  def pub_date
    self.created_at.strftime("%B, %e %Y")
  end

  def title
    self.item_text[0..50]
  end

end
