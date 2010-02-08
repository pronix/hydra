class AttachmentFile < UserFile
  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 2.megabytes
end
