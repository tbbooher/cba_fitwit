class FitnessCampInfoController < ApplicationController

  def index
    @pagetitle = "Fitness Camp Details"
    schedule_data
  end

  def the_fitwit_difference
    @pagetitle = "The Fitwit Difference"
  end

end
