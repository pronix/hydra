# -*- coding: utf-8 -*-
c = YAML::load(File.open("#{RAILS_ROOT}/config/email.yml"))
delivery_method = c[RAILS_ENV]['email']['delivery_method']

case delivery_method
when /sendmail/
  ActionMailer::Base.delivery_method = :sendmail
when /test/
  ActionMailer::Base.delivery_method = :test
when /smtp/
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address        => c[RAILS_ENV]['email']['server'],
    :port           => c[RAILS_ENV]['email']['port'],
    :domain         => c[RAILS_ENV]['email']['domain'],
    :authentication => c[RAILS_ENV]['email']['authentication'],
    :user_name      => c[RAILS_ENV]['email']['username'],
    :password       => c[RAILS_ENV]['email']['password']
  }
end

SITE_ADMIN_EMAIL = c[RAILS_ENV]['email']['site_admin_email']
WEB_HOST = c[RAILS_ENV]['web_host']




