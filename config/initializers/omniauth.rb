# -*- encoding : utf-8 -*-

require 'openid/store/filesystem'
require File.join(Rails.root,'config/omniauth_settings')
# we need to modify this to populate ENV

Rails.application.config.middleware.use OmniAuth::Builder do
  # if defined? ENV['OMNIAUTH_GOOGLE']
  #   #provider :google_apps, OpenID::Store::Filesystem.new('/tmp/openid.store')
  #   provider :google_apps, OpenID::Store::Filesystem.new('/tmp/openid.store'), :domain => 'gmail.com'
  # end
  
  # if defined? ENV['OMNIAUTH_OPENID']
  #   provider :open_id, OpenID::Store::Filesystem.new(Rails.root+'/tmp/openid.store')
  # end
  # provider( :twitter, ENV['OMNIAUTH_TWITTER_KEY'], ENV['OMNIAUTH_TWITTER_SECRET'], {:client_options => {:ssl => {:ca_path => ENV['OMNIAUTH_CAPATH']}}} ) if defined?(ENV['OMNIAUTH_TWITTER_KEY'])
  # provider( :facebook, ENV['OMNIAUTH_FACEBOOK_KEY'], ENV['OMNIAUTH_FACEBOOK_SECRET']) if defined?(ENV['OMNIAUTH_FACEBOOK_KEY'])
  # provider( :linked_in, ENV['OMNIAUTH_LINKED_IN_KEY'], ENV['OMNIAUTH_LINKED_IN_SECRET']) if defined?(ENV['OMNIAUTH_LINKED_IN_KEY'])
  # #provider( :thirty_seven_signals, ENV['OMNIAUTH_BASECAMP_ID'], ENV['OMNIAUTH_BASECAMP_SECRET']) if defined?(ENV['OMNIAUTH_BASECAMP_ID'])
  # provider( :github, ENV['OMNIAUTH_GITHUB_ID'], ENV['OMNIAUTH_GITHUB_SECRET']) if defined?(ENV['OMNIAUTH_GITHUB_ID'])
  # provider( :campus, ENV['OMNIAUTH_CAMPUS_ID'], ENV['OMNIAUTH_CAMPUS_SECRET'], ENV['OMNIAUTH_CAMPUS_URL']) if defined?(ENV['OMNIAUTH_CAMPUS_ID'])
  #provider :LDAP, "LDAP-Login #{LDAP_HOST}", { :host => LDAP_HOST, :port => LDAP_PORT, :method => :plain,
  #         :base => LDAP_TREEBASE, :uid => 'uid', :bind_dn => "uid=%s,cn=users,dc=xs1,dc=intern,dc=wwedu,dc=com" }
end


module OmniAuth
  module Strategies
    autoload :Campus, File::join(Rails.root,'lib/campus_authorization')
  end
end

