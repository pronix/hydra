class Profile < ActiveRecord::Base
  validates_presence_of :name, :login, :password, :host
  validates_inclusion_of :host, :in => Common::Host::valid_options
  default_scope :order => "created_at DESC"
end
