source 'http://rubygems.org'

gem 'simplecov', :require => false, :group => :test #, '>= 0.4.0'

gem "rails", "3.2.0" #, "3.1.2" #, "~> 3.1.0" # prev was rc8

# Rails 3.1 - Asset Pipeline
group :assets do
  gem 'sass-rails', "~> 3.2.3"
  # gem 'coffee-script'
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', ">= 1.0.3"
  gem 'json'

  gem 'therubyracer'
  gem 'execjs'
  gem 'sprockets', '~> 2.1.2'
end

# Bundle gems needed for Mongoid
gem 'jquery-rails'
gem "mongo"
gem "mongoid", ">= 2.4.4"  #, :path => "/Users/aa/Development/R31/mongoid-1"
gem "bson_ext" #, "1.3.1" #, "1.1.5"

# Bundle gem needed for Devise and cancan
gem "devise", ">= 2.0.0" #, :git => 'git://github.com/iboard/devise.git' #:path => "/Users/aa/Development/R31/devise" #'1.2.rc2' #, "~>1.4.0" # ,"1.1.7"
gem "cancan"

gem 'omniauth-github' #, :git => 'git://github.com/intridea/omniauth-github.git'
gem 'omniauth-openid' #, :git => 'git://github.com/intridea/omniauth-openid.git'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

#gem "omniauth", '~> 1.0.1' #:git => 'git://github.com/intridea/omniauth.git' # "0.2.6"
#gem "omniauth-google-oauth2"

#gem 'omniauth-openid'

# Bundle gem needed for paperclip and attachments
# gem "paperclip" dependency of mongoid-paperclip
gem "mongoid-paperclip", :require => 'mongoid_paperclip'
gem "aws-sdk"
gem 'prawn'

# MongoID Extensions and extras
gem 'mongoid-tree', :require => 'mongoid/tree'
gem 'mongoid_fulltext'
gem 'mongoid_taggable'
gem 'mongoid_spacial' # For GeoIndex
gem 'mongoid_session_store'

# Bundle gems for views
gem "haml"
gem "will_paginate", "3.0.pre4"
gem 'escape_utils'
gem "RedCloth", "4.2.3" #"4.2.4.pre3 doesn't work with ruby 1.9.2-p180

# Gems by iboard.cc <andreas@altendorfer.at>
gem "jsort", "~> 0.0.1"
gem 'progress_upload_field', '~> 0.0.1'


# Markdown
# do "easy_install pygments" on your system
gem 'redcarpet', '1.17.2'
gem 'albino'
gem "nokogiri", "1.4.6"

# tim booher custom gems

gem 'heroku'

# Testing
group :development, :test do
  #gem 'linecache', git: 'git://github.com/mark-moseley/linecache.git'
  gem 'jasmine' #, '1.0.2.1'
  gem 'headless', '0.1.0'  
  # gem 'rspec', '2.6.0'
  gem 'mongoid-rspec', ">= 1.4.4"
  gem 'rspec-rails', git: 'git://github.com/rspec/rspec-rails.git' # '>= 2.8.1'
  gem 'json_pure'
  gem 'capybara'  # , git: 'git://github.com/jnicklas/capybara.git'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork', '0.9.0.rc9'
  #gem "spork", "> 0.9.0.rc"
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-livereload'
  gem 'spork-testunit'
  #gem 'addressable'
  gem 'launchy', '2.0.5'
  gem 'factory_girl_rails', ">= 1.6.0"
  gem 'ZenTest', '4.5.0'
  gem 'autotest'
  gem 'autotest-rails'
  gem 'ruby-growl'
  gem 'autotest-growl'
  gem "mocha"
  gem "gherkin"
  gem 'syntax' 
  gem "nifty-generators"
  gem "rails-erd"
  gem 'rdoc'
  gem 'unicorn'
  gem 'yard'
  gem 'test-unit'
  gem 'rails3-generators'
  gem "haml-rails"
  gem 'faker'
  gem 'ruby-prof' # , :git => 'git://github.com/wycats/ruby-prof.git'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
end

# custom FitWit gems
gem 'activemerchant', :require => 'active_merchant' # , :git => 'git://github.com/tbbooher/active_merchant.git'
#gem 'gibberish'
gem 'ssl_requirement'
#gem 'event-calendar', :require => 'event_calendar'
#gem 'white_list_formatted_content'
#gem 'activerecord-tableless-0.1.0'
#gem 'google_charts_on_rails'
gem 'googlecharts'
gem 'inherited_resources'
gem 'table_builder', :git => 'git://github.com/raw1z/table_builder.git'
#gem 'ym4r_gm'
#gem 'acts_as_list'
#gem 'newrelic_rpm'
#gem 'us_states'
#gem 'transitions'
#gem "transitions", :require => ["transitions", "active_record/transitions"]
gem 'stateflow'
#gem 'validates_multiparameter_assignments'
#gem 'gemsonrails'
#gem 'query_reviewer'
#gem 'white_list'
gem 'wkhtmltopdf-binary'
gem "stamp"
gem "pdfkit" #, :git => "git://github.com/huerlisi/PDFKit.git"
#gem "jquery-rest"
gem 'has_scope', '~> 0.5.1'
gem 'kaminari'
gem "responders"
gem 'simple_form', '~> 2.0.0.rc'
#gem 'client_side_validations'
gem 'bootstrap-sass', '~> 2.0.0'
