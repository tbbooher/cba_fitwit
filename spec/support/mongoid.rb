RSpec.configure do |configuration|
  configuration.include Mongoid::Matchers, type: :model
end
