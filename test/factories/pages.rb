FactoryGirl.define do
factory :page do
   title                 'Page 1'
   body                  "Lorem ipsum"
   show_in_menu          true
   allow_comments        true
   allow_public_comments true
   allow_removing_component true
   is_draft              false
   interpreter           :markdown
end

factory :page_with_default_template, :class => Page do
  title                 'Page 1'
  body                  "Lorem ipsum"
  show_in_menu          true
  allow_comments        true
  allow_public_comments true
  allow_removing_component true
  is_draft              false
  interpreter           :markdown
  page_template         PageTemplate.find_or_create_by(:name => 'default', :html_template => "TITLE BODY COMPONENTS COMMENTS BUTTONS")
end
end

