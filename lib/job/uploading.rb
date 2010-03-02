require 'net/ftp'
module Job
  module Uploading

    def process_uploading
      # Загрузка полученный файлов на mediavalise
      mediavalise_uploading

      # Загрузка скрин листов на imagehosting
      screen_list_uploading

      # Загрузка обложек на imagehosting
      covers_uploading

      job_completion!
    rescue => ex
      erroneous!(ex.message)
    end

    def re_uploading_screen_list
      # Загрузка скрин листов на imagehosting
      screen_list_uploading
      finish_reuploading!
    rescue => ex
      erroneous!(ex.message)
    end

    def re_uploading_cover

      # Загрузка обложек на imagehosting
      covers_uploading
      finish_reuploading!
    rescue => ex
      erroneous!(ex.message)
    end

  end
end

