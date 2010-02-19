class DownloadingFile < ActiveRecord::Base
  STATUS_DOWNLOAD = {
    "0" => "If all downloads are successful.",
    "1" => "If an unknown error occurs.",
    "2" => "If time out occurs.",
    "3" => "If a resource is not found.",
    "4" => "If aria2 sees the specfied number of 'resource not found' error. See --max-file-not-found option).",
    "5" => "If a download aborts because download speed is too slow. See --lowest-speed-limit option)",
    "6" => "If network problem occurs.",
    "7" => "If there are unfinished downloads. This error is only reported if all finished downloads are successful and there are unfinished downloads in a queue when aria2 exits by pressing Ctrl-C by an user or sending TERM or INT signal."
  }

  # include AASM
  belongs_to :task
  # aasm_column :status

  # aasm_initial_state :active
  # aasm_state :active
  # aasm_state :error
  # aasm_state :complete

  # aasm_event :completed do
  #   transitions :to => :complete, :from => :active
  # end

  # aasm_event :erroneous do
  #   transitions :to => :error, :from => :active
  # end

  include Workflow
  workflow do
    state :active do
      event :completed, :transitions_to => :complete
      event :erroneous, :transitions_to => :error
    end
    state :error
    state :complete
  end

  self.workflow_spec.states.keys.each {  |state|
    named_scope state, :conditions => { :workflow_state => state.to_s }
  }

  class << self
    def process
      @tell = Aria2cRcp.tell_active

      # Записываем статус скачивания
      @active = @tell.map {|x|{ :gid => x["gid"], :speed => x["downloadSpeed"],
          :total_length => x["totalLength"] ,  :completed_length => x["completedLength"]}}

      !@active.blank? && DownloadingFile.transaction do
        @active.each {|x|
          @dwn_file = find_by_gid(x[:gid])
          @dwn_file.update_attributes({ :speed => x[:speed],
                                        :total_length => x[:total_length],
                                        :completed_length => x[:completed_length]  })
        }
      end

      # Проверка завершено ли скачивания
      Task.downloading.each {  |task|

        task.downloading_files.map {  |f|
          if file_status = Aria2cRcp.status(f.gid.to_s)

            if file_status["status"] && file_status["status"]["complete"]
              f.completed_length = f.total_length
              f.completed! if f.active?
            elsif file_status["status"] && file_status["status"]["error"]
              f.comment = STATUS_DOWNLOAD[file_status["errorCode"]]
              f.erroneous! if f.active?
            end

          end
        }

        task.downloading_files.reload
        task.check_downloading
      }

    end

  end


end


