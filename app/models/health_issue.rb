class HealthIssue
  include Mongoid::Document

  embedded_in :user
  belongs_to :medical_condition
  field :explanation, type: String, default: "Please explain"

end
