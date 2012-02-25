class OfferSweeper  < ActionController::Caching::Sweeper
  observe Offer

  def sweep
    expire_page price_path
    expire_page getting_started_path
  end

  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep

end