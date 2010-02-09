class Cover < Asset
  has_attached_file :attachment,
  :styles => { :thumb => "100x100>" },
  :path => ":rails_root/data/covers/:attachment/:id/:style.:extension"
  validates_attachment_presence :attachment

  validates_attachment_size :attachment, :less_than => 5.megabytes
  validates_attachment_content_type :attachment, :content_type => ['image/jpeg', 'image/png']
  before_post_process :image?

end
