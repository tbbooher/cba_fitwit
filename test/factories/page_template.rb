FactoryGirl.define do
 factory :page_template do
   name           "default"
   css_class      "default"
   html_template  "<h1>TITLE</h1>COVERPICTURE<hr>BODY<hr>COMPONENTS<hr>BUTTONS<hr>COMMENTS"
 end
end
