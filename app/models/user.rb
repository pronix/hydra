class User < ActiveRecord::Base
  acts_as_authentic  do |c|
    c.login_field = 'email'
  end
  validates_presence_of :notification_email
  
  before_validation :set_notification_email
  def set_notification_email
    if self.notification_email.blank?
      self.notification_email = self.email
    end
  end
end
