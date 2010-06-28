class Task < ActiveRecord::Base

  include Workflow
  include Job::Downloading
  include Job::Extracting
  include Job::GenerationScreenList
  include Job::Rename
  include Job::Packing
  include Job::Uploading
  include Job::UploadingToMediavalise
  include Job::UploadingCovers
  include Job::UploadingScreenList

  ROOT_PATH_DOWNLOAD = Settings.root_path_download
  MAX_ACTIVE_TASK = Settings.max_active_task
  default_scope :order => "created_at DESC"



  # associations
  has_many :job_loggings, :dependent => :delete_all do
    def error
      all(:conditions => ["job not in (?) ", "error"]).last.comment
    rescue
      ""
    end
    def start_job(comment = "")
      (find_by_job(proxy_owner.reload.current_state.to_s) ||
       create(:job => proxy_owner.reload.current_state.to_s)).
        update_attributes!({:startup => Time.now.to_s(:db), :comment => comment })
    end

    def end_job(comment = "")
      (find_by_job(proxy_owner.reload.current_state.to_s) ||
       create(:job => proxy_owner.reload.current_state.to_s)).
        update_attributes!({ :stop_time => Time.now.to_s(:db), :comment => comment })
    end

  end

  belongs_to :category
  belongs_to :user
  # files

  # has_many :covers , :as => :assetable, :dependent => :destroy
  has_many :attachment_files , :as => :assetable, :dependent => :destroy, :class_name => "UserFile"
  has_many :list_screens, :dependent => :destroy
  has_many :task_covers , :dependent => :destroy

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

  # validate :macro_renaming_checking
  # def macro_renaming_checking
  #   errors.add(:macro_renaming, :invalid) if rename? && !macro_renaming.split('.').all? {|x|
  #     Common::RenameMacros.list.include?(x) }
  # end

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
  named_scope :active, :conditions => [" workflow_state not in(?) ", %w(completed)]
  named_scope :active_without_self, lambda { |t| {
      :conditions => [" tasks.workflow_state not in(?) and tasks.id not in (?) ", %w(completed error), t.read_attribute(:id) ]
    }}
  named_scope :completed, :conditions => [" workflow_state in (?) ", %w(completed error)]
  named_scope :filter, lambda{ |cond, argv|
    raise "Пустые параметры поиска" if cond.blank?
    { :conditions => [cond,argv] }}


  # callback

  after_create :new_task
  before_destroy :clear_task
  after_destroy :run_next_task
 # Если удаляем задача нужно удалить закачанные файлы
  def clear_task
    @path = task_path
    FileUtils.rm_rf(@path)
    log "delete task files #{@path}"
    downloading_files.each do |file|
      log "remove job aria ##{file.gid}"
      Aria2cRcp.remove(file.gid.to_s) rescue nil
    end
  end

  # После удаления если есть задача в очереди то запускаем ее
  def run_next_task
    begin
      @_task = user.tasks.queued.first
      @_task && (user.tasks.active.size < MAX_ACTIVE_TASK ) && @_task.start_downloading!
    rescue Workflow::TransitionHalted => ex
      erroneous!(ex.message)
    end
  end

  # если активнх задач нету отправляем задачу на скачивания
  def new_task
    start_job
    # active_tasks = user.tasks.active_without_self(self)
    start_downloading! if user.tasks.active_without_self(self).size < MAX_ACTIVE_TASK
  rescue Workflow::TransitionHalted => ex
    erroneous!(ex.message)
  end

  # Если задача завершаеться с ошибкой то  отправляем следующию задачу на выполнение
  def process_error
    @_task = user.tasks.queued.first
    if @task &&  user.tasks.active_without_self(self).blank?
      @_task.end_job
      @_task.start_downloading!
      sleep(1)
      @_task.start_job
    end
  end


  # средняя скорость загрузки по все файлам
  def speed
    # @_speed = read_attribute(:speed)
    # return @_speed unless  @_speed.to_i == 0
    return 0 if downloading_files.active.blank?
    (downloading_files.active.sum(:speed)/ downloading_files.active.count)/1.kilobyte
  rescue
    0
  end
  # процент скачанного объекма файлов
  def percentage
    return read_attribute(:percentage).to_i if downloading_files.active.blank?
    completed_length = downloading_files.active.map{ |x| x.completed_length.to_i }.sum
    total_length = downloading_files.active.map{ |x| x.total_length.to_i }.sum
    return 0 if total_length.to_i == 0
    (completed_length/100)/total_length.to_f
  rescue
    0
  end

  #
  # Выбирает ссылки из текста для ссылок
  def extract_link(text_links=self.links)
    !text_links.blank? ? URI.extract(text_links).uniq : false
  end

  # Добавление  обложек к задаче
  def task_covers=(attr)
    attr.each do |cover|
      task_covers.build( :cover => Cover.create!(:attachment => cover ))
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

  [[:downloding_path,'download'], [ :unpacked_path,'unpacked'], [:screen_list_path,'screen_list'],
   [ :packed_path,'packed'], [ :uploading_path,'uploading'] ].each do |method|
    define_method(method.first) do
      File.join(task_path, method.last)
    end
  end


  workflow do


    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Новая задач (в очереди )
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    state :queued do

      event :start_downloading, :transitions_to => :downloading do
        halt!("Нет ответа от сервера закачек") unless aria_ping?
        end_job
      end
      event :erroneous, :transitions_to => :error do |*message|
        end_job(message.first)
      end


    end



    state :job_finish do


      on_entry do |prior_state, triggering_event, *event_args|
        write_attribute(:previous_state, prior_state.to_s)
        save!
        case prior_state.to_sym
        when :downloading # завершилось скачивание
          case
          when extracting_files?                                then send_later :start_extracting!
          when screen_list?                                     then send_later :start_generation!
          when rename? && that_rename[Common::ThatRename::FILE] then send_later :start_renaming!
          when create_archive?                                  then send_later :start_packing!
          else
            send_later :start_uploading!
          end

        when :extracting # завершилось распаковка
          case
          when screen_list?                                     then start_generation!
          when rename? && that_rename[Common::ThatRename::FILE] then start_renaming!
          when create_archive?                                  then start_packing!
          else
            start_uploading!
          end

        when :generation #
          case
          when rename? && that_rename[Common::ThatRename::FILE] then start_renaming!
          when create_archive?                                  then start_packing!
          else
            start_uploading!
          end

        when :renaming #
          case
          when create_archive? then start_packing!
          else
            start_uploading!
          end

        when :packing #
          start_uploading!

        when :uploading #
          start_finished!
        end
      end


      event :start_extracting, :transitions_to => :extracting
      event :start_renaming,   :transitions_to => :renaming
      event :start_generation, :transitions_to => :generation
      event :start_packing,    :transitions_to => :packing
      event :start_uploading,  :transitions_to => :uploading
      event :start_finished,   :transitions_to => :finished

    end
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Ошибка
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    state :error do
      on_entry { |prior_state, triggering_event, *event_args|
        start_job
        Notification.deliver_stopped_task(self) if user.notification_email?
      }
    end

    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Скачивание
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    state :downloading do

      on_entry { |prior_state, triggering_event, *event_args|
        log "start download"
        start_job
        send_later :to_aria

      }

      # При выходе копируем скачанные файлы в папку для закачки
      on_exit do |new_state, triggering_event, *event_args|
        copy_file_to_uploading(downloding_path)
        log "stop download"
      end

      event :completion_downloading, :transitions_to => :job_finish do |*message|
        downloading_files.destroy_all
        end_job(message.first)
      end
      event :erroneous, :transitions_to => :error do |*message|
        end_job(message.first)
      end

    end

    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Распаковка файлов
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    state :extracting do
      event :job_completion, :transitions_to => :job_finish do |*message|
        end_job(message.first)
        log "stop unpacked"
      end
      event :erroneous, :transitions_to => :error do |*message|
        end_job(message.first)
      end
      on_entry { |prior_state, triggering_event, *event_args|
        log "start unpacked"
        start_job
        process_of_unpacking
      }
    end

    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Генерация скрин листов
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    state :generation do
      event :job_completion, :transitions_to => :job_finish do |*message|
        end_job(message.first)
        log "stop generation"
      end
      event :erroneous, :transitions_to => :error do |*message|
        end_job(message.first)
      end
      event :finish_regenerate, :transitions_to => :finished do |*message|
        end_job(message.first)
      end
      on_entry { |prior_state, triggering_event, *event_args|
        start_job
        case triggering_event.to_s
        when /regenerate/
          send_later :re_process_of_generation_screen_list
        else
          send_later :process_of_generation_screen_list
        end
      }
    end

    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Переименовыание файлов
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    state :renaming do
      event :job_completion, :transitions_to => :job_finish do |*message|
        end_job(message.first)
        log "stop renaming"
      end
      event :erroneous, :transitions_to => :error do |*message|
        end_job(message.first)
      end
      on_entry { |prior_state, triggering_event, *event_args|
        log "start renaming"
        start_job
        process_renaming

      }

      # При выходе копируем переименовыванные файлы файлы в папку для закачки
      on_exit do |new_state, triggering_event, *event_args|
        copy_file_to_uploading(unpacked_path)

      end
    end

    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Упаковка файлов
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    state :packing do
      event :job_completion, :transitions_to => :job_finish do |*message|
        end_job(message.first)
        log "stop packing"
      end

      event :erroneous, :transitions_to => :error do |*message|
        end_job(message.first)
      end

      on_entry { |prior_state, triggering_event, *event_args|
        log "start packing"
        start_job
        process_packing
      }

      # При выходе копируем упакованные файлы в папку для закачки
      on_exit do |new_state, triggering_event, *event_args|
        copy_file_to_uploading(packed_path)
      end
    end

    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Загрузка файлов на сервисы
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    state :uploading do
      event :job_completion, :transitions_to => :job_finish do |*message|
        log "stop uploading"
        end_job(message.first)
      end
      event :erroneous, :transitions_to => :error do |*message|
        end_job(message.first)
      end

      event :finish_reuploading, :transitions_to => :finished do |*message|
        end_job(message.first)
      end

      on_entry { |prior_state, triggering_event, *event_args|
        start_job
        log "start uploading"

        case triggering_event.to_s
        when /reuploading\b/
          send_later :re_uploading_screen_list
        when /reuploading_covers\b/
          send_later :re_uploading_cover
        else
          process_uploading
        end
      }

    end

    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Завершение задачи
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    state :finished do

      event :complete, :transitions_to => :completed do |*message|
        end_job(message.first)
      end

      event :erroneous, :transitions_to => :error do |*message|
        end_job(message.first)
      end

      event :regenerate, :transitions_to => :generation do |*message|
        end_job(I18n.t("restart_generate_screen_list"))
      end

      event :reuploading, :transitions_to => :uploading do |*message|
        end_job(I18n.t("restart_uploading_screen_list"))
      end
      event :reuploading_covers, :transitions_to => :uploading do |*message|
        end_job(I18n.t("restart_uploading_covers"))
      end

      on_entry { |prior_state, triggering_event, *event_args|
        start_job
        FileUtils.rm_rf(downloding_path)
        Notification.deliver_completed_task(self) if user.notification_email?
      }
    end

    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Закрытие задачи
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    state :completed do
      on_entry { |prior_state, triggering_event, *event_args|
        start_job
        FileUtils.rm_rf(task_path)
        run_next_task
      }
    end

    on_transition do |from, to, triggering_event, *event_args|
      log "job: from #{from} to #{to} "
    end

  end

  # state named scope
  (self.workflow_spec.states.keys).each {  |state|
    named_scope state, :conditions => { :workflow_state => state.to_s }
  }


  def state
    if job_finish? && !previous_state.blank?
      I18n.t("state.#{read_attribute("previous_state")}")
    else
      I18n.t("state.#{current_state.to_s}")
    end
  end


  def copy_file_to_uploading(dest_path)
    if  File.exist?(dest_path) && !Dir.glob(dest_path + "**/**").blank?
      FileUtils.rm_rf(uploading_path)
      FileUtils.mkdir_p(uploading_path)
      Dir.glob(dest_path + "**/**").each do |task_file|
        `cp  '#{task_file}' '#{File.join(uploading_path, File.basename(task_file))}'`
      end
    end
  rescue => ex
    erroneous!(ex.message)
  end

  def log message, level = :info
    _message = "[ Task##{read_attribute(:id)}] [#{Time.now.to_s}] #{message}"
    self.class.log _message, level
  end


  def self.log message, level = :info
    job_log ||= Task.open_log
    job_log.send level, message
  end
  def self.open_log
    ActiveSupport::BufferedLogger.new(File.join(RAILS_ROOT, 'log', 'jobs.log'))
  end

end



