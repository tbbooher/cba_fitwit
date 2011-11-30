class Backend::TimeSlotsController < Backend::ResourceController
  nested_belongs_to :location, :fitness_camp
end
