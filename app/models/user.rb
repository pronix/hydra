class User < ActiveRecord::Base
  acts_as_authentic  do |c|
    c.login_field = 'email'
  end
  default_scope :order => "created_at DESC"
  
  # validations
  validates_presence_of :notification_email
  before_validation :set_notification_email
  def set_notification_email
    if self.notification_email.blank?
      self.notification_email = self.email
    end
  end
  
  # associations
  # задачи, если пользователя удаляют то в задача user_id == nil
  has_many :tasks, :dependent => :nullify
  
end
