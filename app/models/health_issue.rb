class HealthIssue
  include Mongoid::Document

  embedded_in :user
  belongs_to :medical_condition
  field :explanation, type: String
  attr_accessor :has_it

  # should require medical condition
  # must require explanation to have a certain length
  # user must only have a medical condition once
  def has_it
    @has_it
  end

  validates :explanation, presence: true, length: {minimum: 5}
  validates :medical_condition_id, :uniqueness => { :scope => :user_id}

end
