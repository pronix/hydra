require 'open3'
module Job
  module GenerationScreenList
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Генерация скрин листов
    # Получаем список файлов,
    # для каждого видео файла вычисляем продолжительность
    # из задачи берем сколько картинок нужно сделать
    # получим из задачи в каком формате нужны скрин листы
    # и сделаем скрин листы
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    def process_of_generation_screen_list
      @path = screen_list_path
      FileUtils.mkdir_p(@path)



      Dir.glob(unpacked_path + "**/**").each do |video_file|
        type_file = nil
        err = nil
        Open3.popen3("file -i #{video_file}") {|i,o,e| type_file =  o.gets }
        if !type_file.blank? && Common::Video.mime_type.include?(type_file.scan(/video\/\w+/).first)
          file_info = FFMpeg::AVFormatContext.new(video_file)
          duration_file = file_info.duration/1000
          delta = duration_file/30
          (1).upto(30) do |i|
            tc = 100+i*delta
            tc = tc - 100 if tc > duration_file
            out_file = File.join(@path, "#{File.basename(video_file)}_#{i}.jpg" )
            command = "ffmpeg -i #{video_file}  -an -ss #{tc/1000} -vframes 1 -y #{out_file}"
            raise "ffmpeg error" unless system(command)
            # Open3.popen3("ffmpeg -i #{video_file}  -an -ss #{tc} -vframes 1 -y #{out_file}"){|i,o,e|
            #   err = e.gets
            #   raise err unless err.blank?
            # }
          end

        end
      end

      end_job("Count files: #{Dir.glob(@path+ "**/**").size}")

    rescue => ex
      end_job("Error:#{ex.message}")
      erroneous!
      start_job("Error:#{ex.message}")

    end

  end
end
