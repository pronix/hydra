class ListScreen < ActiveRecord::Base
  belongs_to :screen, :dependent => :destroy
end
