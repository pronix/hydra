class JobLogging < ActiveRecord::Base
  default_scope :order => "startup ASC"
end
