class DownloadingFile < ActiveRecord::Base
  STATUS_DOWNLOAD = {
    "0" => "All downloads are successful.",
    "1" => "Unknown error occurs.",
    "2" => "Time out occurs.",
    "3" => "Resource is not found.",
    "4" => "Aria2 sees the specfied number of 'resource not found' error. See --max-file-not-found option).",
    "5" => "Download aborts because download speed is too slow. See --lowest-speed-limit option)",
    "6" => "Network problem occurs.",
    "7" => "There are unfinished downloads. This error is only reported if all finished downloads are successful and there are unfinished downloads in a queue when aria2 exits by pressing Ctrl-C by an user or sending TERM or INT signal."
  }


  belongs_to :task
  serialize :options, Hash

  include Workflow
  workflow do
    state :queued do
      event :start, :transitions_to => :active
      event :erroneous, :transitions_to => :error
    end

    state :active do
      event :completed, :transitions_to => :complete
      event :erroneous, :transitions_to => :error

      # Старт скачивание файла
      # и переводим скачивание в активное состояние
      on_entry do |prior_state, triggering_event, *event_args|
        @gid = Aria2cRcp.add_uri([self.uri], self.options)
        self.update_attributes!({ :gid => @gid }) if @gid

      end

    end
    state :error
    state :complete
  end

  self.workflow_spec.states.keys.each {  |state|
    named_scope state, :conditions => { :workflow_state => state.to_s }
  }

  named_scop :ungid, :conditions => ["gid is not null"]

  class << self
    def process
      @tell = Aria2cRcp.tell_active

      # Записываем статус скачивания
      @active = @tell.map {|x|{ :gid => x["gid"], :speed => x["downloadSpeed"],
          :total_length => x["totalLength"] ,  :completed_length => x["completedLength"]}}

      !@active.blank? && DownloadingFile.transaction do
        @active.each {|x|
          @dwn_file = find_by_gid(x[:gid])
          @dwn_file && @dwn_file.update_attributes({ :speed => x[:speed],
                                                     :total_length => x[:total_length],
                                                     :completed_length => x[:completed_length]  })
        }
      end


      # Проверка завершено ли скачивания
      _task =[]
      Task.downloading.each {  |task|

        task.downloading_files.ungid.map {  |f|

          # Получаем статус скачивание
          if file_status = Aria2cRcp.status(f.gid.to_s)

            # Файл скачан
            if file_status["status"] && file_status["status"]["complete"]
              f.completed_length = f.total_length
              f.completed! if f.active?
              _task << task

            elsif file_status["status"] && file_status["status"]["error"]
              # При скачивание ошибка
              f.comment = STATUS_DOWNLOAD[file_status["errorCode"]]
              f.erroneous! if f.active?
            end

          end

        }

        # Проверяем если у задачи нет активных подзадач на скачивание
        # но есть в очереди то запускаем один из них
        task.downloading_files.reload # обновляем данные из базы
        if task.downloading_files.active.blank? && !task.downloading_files.queued.blank?
          task.downloading_files.queued.last.start!
        end

      }

      _task.uniq.each {  |task|  task.check_downloading   }
      _task = nil
    end

  end


end


