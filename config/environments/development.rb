Cba::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # I want to debug my javascript in development
  config.assets.debug = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # next line remarked for 3.1     
  # config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = true

  ### ActionMailer Config
  config.action_mailer.default_url_options ||= { :host => ENV['DEFAULT_URL']}
  config.action_mailer.default_url_options[:host] = ENV['DEFAULT_URL']
  
  # A dummy setup for development - no deliveries, but logged
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"


  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :production # :test
  # TODO we should remove this . . .
  ActiveMerchant::Billing::CreditCard.require_verification_value = false

  # we need to open an external file to get the password
  mypassphrase = File.open(File.join(Rails.root, 'passphrase.txt')).read
  OrderTransaction.gateway = ActiveMerchant::Billing::CyberSourceGateway.new(:login    => 'v9526006',
                                                    :password => mypassphrase.to_s,
                                                    :test => false,
                                                    :vat_reg_number => 'your VAT registration number',
                                                    # sets the states/provinces where you have a physical presense for tax purposes
                                                    :nexus => "GA OH",
                                                    # don‘t want to use AVS so continue processing even if AVS would have failed
                                                    :ignore_avs => true,
                                                    # don‘t want to use CVV so continue processing even if CVV would have failed
                                                    :ignore_cvv => true,
                                                    :money_format => :dollars
                                                    )
end


end
