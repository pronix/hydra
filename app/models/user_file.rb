class UserFile < Asset
  has_attached_file :attachment,
  :styles => { :thumb => "100x100>" },
  :path => ":rails_root/data/user_files/:attachment/:id/:style.:extension"
  validates_attachment_presence :attachment
  before_post_process :image?

end
