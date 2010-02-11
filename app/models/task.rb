class Task < ActiveRecord::Base
  include AASM
  default_scope :order => "created_at DESC"

  # aasm

  aasm_column :state
  aasm_initial_state :queued

  aasm_state :queued
  aasm_state :downloading
  aasm_state :extracting
  aasm_state :generation
  aasm_state :renaming
  aasm_state :packing
  aasm_state :uploading
  aasm_state :finished
  aasm_state :completed
  aasm_state :error

  # validations
  validates_presence_of :name, :links
  validates_associated  :category
  validates_presence_of :password, :if => lambda{ |t| t.use_password }

  # validations переименовывание файла
  validates_presence_of  :that_rename, :if => lambda { |t| t.rename? }
  validates_presence_of  :macro_renaming, :if => lambda { |t| t.rename? }
  validates_presence_of  :rename_file_name, :if => lambda { |t| t.rename? }
  validates_inclusion_of :that_rename, :in => Common::ThatRename.valid_options, :if => lambda { |t| t.rename? }



  validate :links_checking
  def links_checking
    errors.add(:links, :invalid) if extract_link.blank?
  end

  # name scope
  named_scope :active, :conditions => [" state not in(?) ", %w(completed error)]
  named_scope :completed, :conditions => [" state in (?) ", %w(completed error)]
  named_scope :filter, lambda{ |cond, argv|
    raise "Пустые параметры поиска" if cond.blank?
    {
      :conditions => [cond,argv],
    }}

  # associations
  has_many :job_loggings
  belongs_to :category

  # files
  has_many :covers, :as => :assetable, :dependent => :destroy
  has_many :attachment_files, :as => :assetable, :dependent => :destroy

  def extract_link(text_links=self.links)
    !text_links.blank? ? URI.extract(text_links) : false
  end
end
