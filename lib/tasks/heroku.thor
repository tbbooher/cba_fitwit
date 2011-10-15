require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/string/inflections'

module PrepHeroku
  extend self

  module Support
    private

    def heroku(command)
      command "heroku #{command} --app fitwit"
    end

    def command(command)
      puts command
      system command
    end

    def environment
      self.class.to_s.demodulize.underscore
    end

    def heroku_env
      @heroku_env ||= PrepHeroku.heroku_config[environment]
    end

    # APPLICATION_CONFIG=YAML.load_file(config_file)[Rails.env]['application']
    # CONSTANTS=YAML.load_file(config_file)[Rails.env]['constants']

    def heroku_application
      @heroku_application ||= PrepHeroku.heroku_config[environment]['application']
    end

    def heroku_constants
      @heroku_constants ||= PrepHeroku.heroku_config[environment]['constants']
    end

    def omni_auth
      @omni_auth = YAML.load_file(File.expand_path('../../../config/omniauth_settings.yml', __FILE__)).with_indifferent_access
    end

    def mail_settings
      @mail_settings = YAML.load_file(File.expand_path('../../../config/mailserver_setting.yml', __FILE__)).with_indifferent_access
    end
  end

  def self.commands_for_environment(app_env)
    module_eval do
      klass = Class.new(Thor) do
        include Support

        desc "rack_env", "Set the RACK_ENV config variable"
        def rack_env
          heroku("config:add RACK_ENV=#{environment}")
        end

        desc "config", "Set config variables"
        def config
          env_values = [].tap do |e|
            # APPLICATION_CONFIG.each{|k,v| ENV["APPLICATION_CONFIG_#{k}"] = v.to_s }
            heroku_application.each do |key, value|
              e << "APPLICATION_CONFIG_#{key}='#{value}'"
            end
            # CONSTANTS.each{|k,v| ENV["CONSTANTS_#{k}"] = v.to_s}
            heroku_constants.each do |key, value|
              e << "CONSTANTS_#{key}='#{value}'"
            end
            omni_auth.each do |key, value|
              e << "#{key}='#{value}'"
            end
            mail_settings.each do |key, value|
              e << "#{key}='#{value}'"
            end
          end
          heroku("config:add #{env_values.join(' ')}")
        end
      end

      const_set(app_env.classify, klass)
    end
  end

  def heroku_config
    @heroku_config ||= YAML.load_file(File.expand_path('../../../config/application.yml', __FILE__)).with_indifferent_access
  end

  #heroku_config[:apps].each_key do |app_env|
    commands_for_environment('production')
  #end
end
