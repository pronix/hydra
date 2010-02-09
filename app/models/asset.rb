class Asset < ActiveRecord::Base
  belongs_to :assetable, :polymorphic => true

  validates_presence_of :title

  # TODO нужно  добавить индекс на это поле
  named_scope :images, :conditions => [%{ attachment_content_type like ? },"image%" ]

  def image?
    !(self.attachment_content_type =~ /^image.*/).nil?
  end


end
