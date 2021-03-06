class AttachmentFile < Asset
  has_attached_file :attachment,
  :styles => { :thumb => "100x100>" },
  :path => ":rails_root/data/arhive_attahments/:attachment/:id/:style.:extension"
  validates_attachment_presence :attachment

  validates_attachment_size :attachment, :less_than => 5.megabytes
  before_post_process :image?

end
