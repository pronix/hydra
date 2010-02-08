class UserFile < ActiveRecord::Base 
  has_attached_file :file,
  :styles => { :thumb => "100x100" },
  :path => ":rails_root/data/user_files/:attachment/:id/:style.:extension"
  
  validates_presence_of :name
  
  before_post_process :image?
  def image?
    !(self.file_content_type =~ /^image.*/).nil?
  end
  
end
