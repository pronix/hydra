class TaskCover < ActiveRecord::Base
  belongs_to :cover, :dependent => :destroy
  def links=(str)
    write_attribute(:links, str.to_yaml)
  end
  def links
   YAML.load(read_attribute(:links)) rescue nil
  end
end
