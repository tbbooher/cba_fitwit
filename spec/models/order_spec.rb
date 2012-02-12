require 'spec_helper'

describe Order do

  before(:all) do
    cleanup_database
    @l = FactoryGirl.create(:location)
  end


end
