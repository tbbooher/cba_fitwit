 # -*- encoding : utf-8 -*-

#require 'openid/store/filesystem'
#require File.join(Rails.root,'config/omniauth_settings')
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['OMNIAUTH_GITHUB_ID'], ENV['OMNIAUTH_GITHUB_SECRET']
  #provider :google_oauth2, ENV['OMNIAUTH_GOOGLE_KEY'], ENV['OMNIAUTH_GOOGLE_SECRET']
  provider :facebook, ENV['OMNIAUTH_FACEBOOK_ID'], ENV['OMNIAUTH_FACEBOOK_SECRET']
  provider :twitter, ENV['OMNIAUTH_TWITTER_CONSUMER_KEY'], ENV['OMNIAUTH_TWITTER_SECRET']
end


#module OmniAuth
#  module Strategies
#    autoload :Campus, File::join(Rails.root,'lib/campus_authorization')
#  end
#end
