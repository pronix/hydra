class User < ActiveRecord::Base
  acts_as_authentic  do |c|
    c.login_field = 'email'
  end

  acts_as_authorization_subject
  # Associated with Roles
  has_and_belongs_to_many :roles

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
  has_many :proxies
  has_many :macros, :class_name => "Macros"
  has_many :user_files, :as => :assetable, :dependent => :destroy


  has_many :profiles do
    def mediavalise
      all :conditions => { :host => Common::Host::MEDIAVALISE}
    end
    def without_mediavalise
    all :conditions => [ " host not in(?) ", Common::Host::MEDIAVALISE]
    end
  end

  def admin?
    has_role? :admin
  end

end
