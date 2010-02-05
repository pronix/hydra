class Category < ActiveRecord::Base
  
  # validations
  validates_presence_of :name
  
  # associations
  has_many :tasks, :dependent => :nullify
  
end
