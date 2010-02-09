class Macros < ActiveRecord::Base
  belongs_to :logo, :class_name => UserFile
end
