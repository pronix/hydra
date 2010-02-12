class Task < ActiveRecord::Base
  ROOT_PATH_DOWNLOAD = File.join(RAILS_ROOT, "data", "download")
  include AASM
  default_scope :order => "created_at DESC"


  after_create :new_task
  # aasm

  aasm_column :state
  aasm_initial_state :queued

  aasm_state :queued                              # новая задача

  aasm_state :downloading,   :enter => :to_aria   # скачивание
  aasm_state :download                            # скачан

  aasm_state :extracting
  aasm_state :generation
  aasm_state :renaming
  aasm_state :packing
  aasm_state :uploading
  aasm_state :finished
  aasm_state :completed
  aasm_state :error


  # скачивание
  aasm_event :start_downloading do
    transitions :to => :downloading, :from => :queued, :guard => :aria_ping?
  end


  aasm_event :stop_downloading do
    transitions :to => :download, :from => :downloading
  end

  aasm_event :to_error do
    transitions :to => :error, :from => [ :queued, :downloading, :download,
                                          :extracting, :generation, :renaming,
                                          :packing, :uploading, :finished,
                                          :completed, :error ]
  end


  # associations
  has_many :job_loggings do
    def start_job(comment = "")
      @job = create(:job => proxy_owner.aasm_current_state.to_s, :startup => Time.now.to_s(:db))
    end
    def end_job(comment = "")
      @job = find_by_job(proxy_owner.aasm_current_state.to_s)
      @job.update_attributes!({ :stop_time => Time.now.to_s(:db), :comment => comment })
    end
  end

  belongs_to :category
  belongs_to :user
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
  named_scope :active_without_self, lambda { |t| {
      :conditions => [" tasks.state not in(?) and tasks.id not in (?) ", %w(completed error), t.read_attribute(:id) ]
    }}
  named_scope :completed, :conditions => [" state in (?) ", %w(completed error)]
  named_scope :filter, lambda{ |cond, argv|
    raise "Пустые параметры поиска" if cond.blank?
    {
      :conditions => [cond,argv],
    }}



  def extract_link(text_links=self.links)
    !text_links.blank? ? URI.extract(text_links).uniq : false
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


  def start_job(comment="")
    job_loggings.start_job(comment)
  end
  def end_job(comment="")
    job_loggings.end_job(comment)
  end


  # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  def aria_ping?
    Aria2cRcp.ping
  end

  # если активнх задач нету отправляем задачу на скачивания
  def new_task
    unless user.tasks.active_without_self(self).count > 0
      start_downloading!
    end
  end

  # Создаем путь к файлам
  def to_aria
    job_loggings.start_job("")
    @path = File.join(ROOT_PATH_DOWNLOAD, user.id.to_s, self.id.to_s)
    FileUtils.mkdir_p(File.dirname(@path))
    @options={ "dir" => @path }
    self.gid = Aria2cRcp.add_uri(self.extract_link, @options)
    save! if self.gid
  rescue
    to_error!
  end

end
