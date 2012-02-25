class OfferSweeper  < ActionController::Caching::Sweeper
  observe Offer

  def after_update
    expire_page price_path
    expire_page getting_started_path
  end

end