class Profile < ActiveRecord::Base
  validates_presence_of :name, :login, :password
  default_scope :order => "created_at DESC"
end
