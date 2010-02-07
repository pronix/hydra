class Role < ActiveRecord::Base
  acts_as_authorization_role
  
  has_many :roles_users
  has_many :users, :through => :roles_users
  
  validates_presence_of :name
end
