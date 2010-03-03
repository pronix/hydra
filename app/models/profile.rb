class Profile < ActiveRecord::Base
  validates_presence_of :name, :host
  validates_inclusion_of :host, :in => Common::Host::valid_options
  validates_presence_of :login, :password,
  :if => lambda{ |t| Common::Host::must_have_login_password.include?(t.host) }
  default_scope :order => "created_at DESC"

end
