class Task < ActiveRecord::Base
  include AASM
  default_scope :order => "created_at DESC"

  # aasm

  aasm_column :state
  aasm_initial_state :queued

  aasm_state :queued, :enter => :event
  aasm_state :downloading
  aasm_state :extracting
  aasm_state :generation
  aasm_state :renaming
  aasm_state :packing
  aasm_state :uploading
  aasm_state :finished
  aasm_state :completed
  aasm_state :error

  aasm_event :start_downloading do
    transitions :to => :downloading, :from => :queued
  end

  aasm_event :start_extracting do
    transitions :to => :extracting, :from => :downloading
  end

  def event(comment="")
    job_loggings.logger(comment)
  end
  # associations
  has_many :job_loggings do

    def logger(comment = "")
      if @job = find_by_job(proxy_owner.aasm_current_state.to_s)
        @job.update_attributes!({ :stop_time => Time.now.to_s(:db), :comment => comment })
      else
        @job = create(:job => proxy_owner.aasm_current_state.to_s, :startup => Time.now.to_s(:db))
      end
      @job
    end

  end

  belongs_to :category

  # files

  has_many :covers , :as => :assetable, :dependent => :destroy
  has_many :attachment_files , :as => :assetable, :dependent => :destroy

  belongs_to :screen_list_macro,     :class_name => "Macros"
  belongs_to :upload_images_profile, :class_name => "Profile"
  belongs_to :mediavalise_profile,   :class_name => "Profile"

  # validations
  validates_presence_of :name, :links
  validates_associated  :category
  validates_presence_of :password, :if => lambda{ |t| t.use_password }

  # validations переименовывание файла
  validates_presence_of  :that_rename, :if => lambda { |t| t.rename? }
  validates_presence_of  :macro_renaming, :if => lambda { |t| t.rename? }
  validates_presence_of  :rename_file_name, :if => lambda { |t| t.rename? }
  validates_inclusion_of :that_rename, :in => Common::ThatRename.valid_options, :if => lambda { |t| t.rename? }

  # validations закачка файлов
  validates_presence_of :screen_list_macro_id, :if => lambda{ |t| t.screen_list? }
  validates_presence_of :upload_images_profile_id, :if => lambda{ |t| t.upload_images? }
  validates_presence_of :mediavalise_profile_id, :if => lambda{ |t| t.mediavalise? }

  validates_numericality_of :part_size, :allow_nil => true, :only_integer => true, :if => lambda{ |t| !t.part_size.blank? }


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



  def extract_link(text_links=self.links)
    !text_links.blank? ? URI.extract(text_links) : false
  end

  def covers=(attr)
    attr.each do |cover|
      covers.build(cover)
    end
  end
  def attachment_files=(attr)
    attr.each do |attachment_file|
      attachment_files.build(attachment_file)
    end
  end


end
