Cba::Application.configure do
  # TODO -- remove when we go to production
  config.middleware.insert_after(::Rack::Lock, "::Rack::Auth::Basic", "Beta Site") do |u, p|
    [u, p] == ['fitwit', 'happy']
  end

  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Specify the default JavaScript compressor
  config.assets.js_compressor = :uglifier

  # Specifies the header that your server uses for sending files
  # (comment out if your front-end server doesn't support this)
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.default_url_options = {:host => ::ENV['DEFAULT_URL']}

  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  config.action_mailer.default_url_options = {:host => ENV['DEFAULT_URL']}
  ### ActionMailer Config
  # Setup for production - deliveries, no errors raised
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :production # :test

    mypassphrase = File.open('/var/www/fitwit/shared/passphrase.txt').read
    OrderTransaction.gateway = ActiveMerchant::Billing::CyberSourceGateway.new(:login => 'v9526006',
                                                                :password => mypassphrase.to_s, # 'UaG7kmL/bfcn4lcGN5JFjPBJ9HVCcqS1RiNseIOTHuHue6ZCQcYsHP4rOlhdYWOpJOAQGdyvT6bb0496RuzWN05qypZiN0WzCgWCFFayp5LUoDmrx4H/5u+HUUme4vtmgUmdZKWTSSImP1cIRakwM13+jjj6YKZOOUsNdIXSiOP/89PIwNZD9Y7CVaM3kkWM8En0dUJypLVGI2x4g5Me4e57pkJBxiwc/is6WF1hY6kk4BAZ3K9PptvTj3pG7NY3TmrKlmI3RbMKBYIUVrKnktSgOavHgf/m74dRSZ7i+2aBSZ1kpZNJIiY/VwhFqTAzXf6OOPpgpk45Sw10hdKI4w==',
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

