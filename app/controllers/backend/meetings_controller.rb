class Backend::MeetingsController <  Backend::ResourceController
  belongs_to :location
  belongs_to :fitness_camp
  belongs_to :time_slot
end
