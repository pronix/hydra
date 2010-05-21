# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.middleware.use "Download"
  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem "formtastic"
  config.gem 'authlogic'
  config.gem "workflow", :source => 'http://gemcutter.org'
  config.gem "acl9", :source => "http://gemcutter.org", :lib => "acl9"
  config.gem "geoip"
  config.gem 'paperclip', :source => 'http://gemcutter.org'
  config.gem "inherited_resources", :version => '=1.0.3'
  config.gem "daemon-spawn", :source => 'http://gemcutter.org'
  config.gem 'delayed_job', :lib => 'delayed_job', :source => 'http://gemcutter.org'
  config.gem "httparty", :source => 'http://gemcutter.org'
  #config.gem 'ffmpeg-ruby', :source => 'http://gemcutter.org'
  config.gem "nokogiri", :version => '>=1.4.1'
  config.gem "bluepill", :version => '>=0.0.33'
  config.gem "settingslogic", ">=2.0.6"
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :en


end


ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.yandex.ru',
  :domain         => 'yandex.ru',
  :port           => '25',
  :user_name      => 'hadooptest@yandex.ru',
  :password       => '12345678',
  :authentication => :plain
}


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

# уведомления о ошибках
ExceptionNotification::Notifier.exception_recipients  = %w(pronix.service@gmail.com)
ExceptionNotification::Notifier.email_prefix          = "hydra"
ExceptionNotification::Notifier.sender_address        = "error@hydra.raidosoft.com"
