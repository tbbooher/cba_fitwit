FactoryGirl.define do
  factory :blog do
    title      'Blog 1'
    allow_comments true
    allow_public_comments true
    is_draft   false
  end		
end
