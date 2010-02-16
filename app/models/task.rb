class Task < ActiveRecord::Base
  include AASM
  include Job::Downloading
  include Job::Extracting

  ROOT_PATH_DOWNLOAD = File.join(RAILS_ROOT, "data", "task_files")
  default_scope :order => "created_at DESC"



  # aasm

  aasm_column :state
  aasm_initial_state :queued

  aasm_state :queued                              # новая задача

  aasm_state :downloading,   :enter => :to_aria   # скачивание
  aasm_state :download                            # скачан

  aasm_state :extracting,    :enter => :queued_to_extracting
  aasm_state :generation,    :enter => :queued_to_generation_screen_list
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


  aasm_event :start_extracting do
    transitions :to => :extracting, :from => :downloading
  end

  aasm_event :start_generation do
    transitions :to => :generation, :from => :extracting
  end

  aasm_event :erroneous do
    transitions :to => :error, :from => [ :queued, :downloading, :download,
                                          :extracting, :generation, :renaming,
                                          :packing, :uploading, :finished,
                                          :completed, :error ]
  end


  # associations
  has_many :job_loggings, :dependent => :delete_all do
    def start_job(comment = "")
      @job = create(:job => proxy_owner.reload.aasm_current_state.to_s, :startup => Time.now.to_s(:db))
    end
    def end_job(comment = "")
      @job = find_by_job(proxy_owner.reload.aasm_current_state.to_s) || create(:job => proxy_owner.reload.aasm_current_state.to_s)
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
  has_many   :downloading_files,     :dependent => :delete_all

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


  # callback

  after_create :new_task
  before_destroy :clear_task

 # Если удаляем задача нужно удалить закачанные файлы
  def clear_task
    @path = task_path
    FileUtils.rm_rf(@path)
    Rails.logger.info "[ clear task ] - delete task files #{@path}"
    downloading_files.each do |file|
      Rails.logger.info "[ clear task ] - remove job aria ##{file.gid}"
      Aria2cRcp.remove(file.gid.to_s) rescue nil
    end
  end

  # если активнх задач нету отправляем задачу на скачивания
  def new_task
    start_job
    unless user.tasks.active_without_self(self).count > 0
      end_job
      start_downloading!
      sleep(1)
      start_job
    end
  end


  # средняя скорость загрузки по все файлам
  def speed
    @_speed = read_attribute(:speed)
    return @_speed unless  @_speed.to_i == 0
    return 0 if downloading_files.blank?
    (downloading_files.sum(:speed)/ downloading_files.count)/1.kilobyte
  rescue
    0
  end
  # процент скачанного объекма файлов
  def percentage
    @_percentage = read_attribute(:percentage)
    return @_percentage if @_percentage.to_i == 100
    return 0 if downloading_files.blank?
    (downloading_files.sum(:completed_length)*100)/downloading_files.sum(:total_length)
  rescue
    0
  end

  # Выбирает ссылки из текста для ссылок
  def extract_link(text_links=self.links)
    !text_links.blank? ? URI.extract(text_links).uniq : false
  end

  # Добавление  обложек к задаче
  def covers=(attr)
    attr.each do |cover|
      covers.build(cover)
    end
  end
  # Добавление прикрепленных файлов к задаче
  def attachment_files=(attr)
    attr.each do |attachment_file|
      attachment_files.build(attachment_file)
    end
  end

  # Логирования выполнение работы
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

  # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  # Пути задачи
  # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  def task_path
    File.join(ROOT_PATH_DOWNLOAD, user.id.to_s, self.id.to_s)
  end
  # Путь куда скачиваються файлы этой задачи
  def downloding_path
    File.join(task_path, 'download')
  end

  # Путь куда будут распаковываться файлы
  def unpacked_path
    File.join(task_path, 'unpacked')
  end


  # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  # Распаковка файлов
  # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  def queued_to_extracting
    self.send_later(:process_of_unpacking)
  end


  # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  # Генерация скрин листа
  # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  def queued_to_generation_screen_list
    self.send_later(:process_of_generation_screen_list)
  end

  def process_of_generation_screen_list
    job_loggings.create(:job => :generation.to_s, :startup => Time.now.to_s(:db) )

  end

end
