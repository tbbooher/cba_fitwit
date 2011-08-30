class FitnessCampInfoController < ApplicationController
  skip_before_filter :check_authentication, :check_authorization


  def index
    @pagetitle = "Fitness Camp Details"
    schedule_data
  end

  def the_fitwit_difference
    @pagetitle = "The Fitwit Difference"
  end

end
