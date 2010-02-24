class ListScreen < ActiveRecord::Base
  belongs_to :screen, :dependent => :destroy
  # serialize :links, Array
  def links=(str)
    write_attribute(:links, str.to_yaml)
  end
  def links
   YAML.load(read_attribute(:links)) rescue nil
  end
end
