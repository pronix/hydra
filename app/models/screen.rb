class Screen < Asset
  has_attached_file :attachment,
  :styles => { :thumb => "300x300>" },
  :path => ":rails_root/data/screen/:attachment/:id/:style.:extension",
  :url => "assets/screen/:attachment/:id/:style.:extension"

  validates_attachment_presence :attachment

  validates_attachment_size :attachment, :less_than => 15.megabytes
  validates_attachment_content_type :attachment, :content_type => ['image/jpeg', 'image/png']
  before_post_process :image?

end
