# -*- encoding : utf-8 -*-

# moved to application.rb
# -> require File::dirname(__FILE__) + "/../mailserver_setting.yml"


require File::dirname(__FILE__) + "/../../lib/development_mail_interceptor.rb"

ActionMailer::Base.smtp_settings = {
  :address              => ENV['MAILSERVER_ADDRESS'],
  :port                 => ENV['MAILSERVER_PORT'],
  :domain               => ENV['MAILSERVER_DOMAIN'],
  :user_name            => ENV['MAILSERVER_USERNAME'],
  :password             => ENV['MAILSERVER_PASSWORD'],
  :authentication       => "plain",
  :enable_starttls_auto => true
}

Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

Cba::Application.config.action_mailer.default_url_options[:host] = ENV['DEFAULT_URL']
