# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem "formtastic"
  config.gem 'authlogic'
  config.gem 'ttilley-aasm',:lib => 'aasm', :source => 'http://gemcutter.org'
  config.gem "acl9", :source => "http://gemcutter.org", :lib => "acl9"
  config.gem "geoip"
  config.gem 'paperclip', :source => 'http://gemcutter.org'
  config.gem "inherited_resources", :version => '=1.0.3'
  config.gem "daemon-spawn", :source => 'http://gemcutter.org'
  config.gem 'collectiveidea-delayed_job', :lib => 'delayed_job', :source => 'http://gemcutter.org'
  config.gem "httparty", :source => 'http://gemcutter.org'
 config.gem 'ffmpeg-ruby', :source => 'http://gemcutter.org'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :en
end

# если ключь локализации не находит то сначала пытаеться вывести default потом  сам ключь в нормальном виде
  module I18n
    class << self
      def just_raise_that_exception(exception, locale, key, options)
        return key.to_s.gsub('.',', ').humanize if I18n::MissingTranslationData === exception
        raise exception
      end
    end
  end

I18n.exception_handler = :just_raise_that_exception
