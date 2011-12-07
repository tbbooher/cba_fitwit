class Backend::LocationsController < Backend::ResourceController

  respond_to :json, only: [:show]
   def show
     @map = true
     super
   end
end
