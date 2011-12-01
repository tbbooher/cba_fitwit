class Backend::LocationsController < Backend::ResourceController
   def show
     @map = true
     super
   end
end
