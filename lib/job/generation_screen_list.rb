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
      @macro = screen_list_macro
      @number_of_frames = @macro.number_of_frames

      @path = screen_list_path
      @path_tmp = File.join(screen_list_path, 'tmp')
      FileUtils.mkdir_p(@path)


      Dir.glob(unpacked_path + "**/**").each do |_video_file|
        video_file = escape_file_name(_video_file)

        type_file = nil
        err = nil
        out_files = []
        Open3.popen3("file -i '#{video_file}'") {|i,o,e| type_file =  o.gets }



        if !type_file.blank? && Common::Video.mime_type.include?(type_file.scan(/video\/\w+/).first)

          FileUtils.rm_rf(@path_tmp) # удаляем сриншоты с придыдущего видео файла
          FileUtils.mkdir_p(@path_tmp)

          # Делаем скриншоты с видео файла
          file_info = ffmpeg_context(video_file)
          duration_file = file_info.duration
          delta = duration_file/@number_of_frames
          video_info = get_video_info(video_file)

          (1).upto(@number_of_frames) do |i|
            tc = ((delta*i -1000)/1000000)
            tc = tc-100 if (duration_file/1000000) <= tc
            out_file = File.join(@path_tmp, "#{File.basename(video_file)}_#{i}.#{@macro.file_format}" )
            out_files << {:file => out_file, :timestamp => tc }
            command = "ffmpeg -i '#{video_file}'  -an -ss #{tc} -vframes 1 -y '#{out_file}'"
            output = `#{command}`
          end


          # Собираем сделанные скриншоты в один скрин лист

          @font_settings = []
          @font_settings << " -font '#{@macro.font}'" unless @macro.font.blank?
          @font_settings << " -pointsize '#{@macro.font_size}'" unless @macro.font_size.blank?
          @font_settings << " -fill '##{@macro.font_color}'" unless @macro.font_color.blank?
          @font_settings = @font_settings.join(' ')

          # Если в макросе указано что нужно добавить шкалу времени то добавляем ее
          @macro.add_timestamp? &&  out_files.map{|x|
            position = Common::PositionTimestamp::values[@macro.position_timestamp]
            text = second_to_s(x[:timestamp])
            cmd = %(convert '#{x[:file]}' -gravity #{position} #{@font_settings} -draw "text 5,5 '#{text}'" '#{x[:file]}' )
            output = `#{cmd}`

          }

          # Расположение изображений
          @tile = %( -tile '#{@macro.columns}x' )
          # рамка
          @border = ""
          @border = %( -bordercolor '##{@macro.frame_color}' -frame '#{@macro.frame_size}' ) if @macro.thumb_frame?
          # качество
          @quality = %( -quality '#{@macro.thumb_quality}' )
          # тень
          @shadow = ""
          @shadow = %( -shadow ) if @macro.thumb_shadow?
          # Фон
          @background = ""
          @background = %( -background '##{@macro.template_background}' ) unless @macro.template_background.blank?

          # размеры картинок
          @thumb_padding = []
          @macro.thumb_padding.scan(/(?:|[+|-])\d+/) {|t|
            @thumb_padding << (t[/[+|-]/] ? t : "+#{t}") } unless @macro.thumb_padding.blank?
          @thumb_padding = [@thumb_padding.first, @thumb_padding.last].join

          @geometry = ""
          @scale = @macro.thumb_width > @macro.thumb_height ? "#{@macro.thumb_width}x" : "x#{@macro.thumb_height}"
          # @scale = "#{@macro.thumb_width}#{@macro.thumb_height}"
          # @scale_sumbol = @macro.thumb_width > @macro.thumb_height ? '>' : '<'
          @geometry = %(-geometry '#{@scale}#{@thumb_padding}' )


          @options = [@tile, @quality, @border, @shadow, @background, @geometry].join(' ')
          input_files = ""
          input_files = out_files.map{|x| "'#{x[:file]}'" }.join(' ')
          out_file = File.join(@path, [File.basename(video_file), @macro.file_format].join('.') )
          montage_command = %( montage #{input_files} #{@options} '#{out_file}')
          log montage_command
          output=`#{montage_command}`

          # Добавляем шапку для логотипа
          @tmp_logo = File.join(@path, ["tmp_logo", @macro.file_format].join('.') )

          unless File.exist? @tmp_logo # создаем только один раз

            if @macro.add_logo?
              @logo = @macro.logo.attachment.path
              @size_screen = parse(`identify -format '%wx%h' '#{out_file}'`)
            end

            # Создаем шаблон логотипа
            command = [" convert ",
                       " -size '#{@size_screen.first}x200' xc:#{!@background.blank? ? @background.split(' ').last : "none"} ",
                       " -gravity 'East' "]
            command << " -draw \" image over 10,0 0,0 '#{@logo}' \" '#{@tmp_logo}'  " if @macro.add_logo?
            command = command.join(' ')
            log "create temp logo"
            log command
            `#{command}`
          end

          # Присоединяем шаблон логотипа к основному скрн листу
          command = [ "convert",
                      "'(' '#{@tmp_logo}' +append ')'",
                      "'(' '#{out_file}' +append ')'",
                      " -gravity 'NorthEast' #{@background} -append '#{out_file}'"
                    ].join(' ')

          log "add logo"
          log command
          output = `#{command}`


          # Добавляем заголовок с техническими данными
          @header_text = @macro.header_text.chomp.
            gsub(/\[file_name\]/,        video_info[:file_name]).
            gsub(/\[width\]x\[height\]/, video_info[:resolution]).
            gsub(/\[duration_time\]/,    video_info[:duration]).
            gsub(/\[file_size\]/,        video_info[:file_size]).
            gsub(/\[video_codec\]/,      video_info[:video_codec]).
            gsub(/\[audio_codec\]/,      video_info[:audio_codec])


          command = ["convert", "'#{out_file}'", "#{@font_settings}",
                     "-gravity 'NorthWest'", " -annotate +15+15 \"#{@header_text}\"",
                     " '#{out_file}' "].join(' ')
          log "add info"
          log command
          output = `#{command}`


        end
      end
      # Удаляем временные файлы
      FileUtils.rm_rf(@path_tmp)
      FileUtils.rm_rf(@tmp_logo)
      end_job("Count files: #{Dir.glob(@path+ "**/**").size}")

    rescue => ex
      log ex.message, :error
      end_job("Error:#{ex.message}")
      erroneous!
      start_job("Error:#{ex.message}")

    end

    private
    def escape_file_name(s)
      s.to_s.gsub(/\\|\n|\r/, '').gsub(/\s+/, " ")
    end

    def log(message, level = :info)
      if Rails.logger.level == 0 && level == :info
        Rails.logger.info '-'*90
        Rails.logger.info " [ generate list ] #{message}"
        Rails.logger.info '-'*90
      elsif [:debug,:warn, :error, :fatal ].include? level
        Rails.logger.send(level, '-'*90)
        Rails.logger.send(level, " [ generate list (#{level}) ] #{message}")
        Rails.logger.send(level, '-'*90)
      end
    end


    def second_to_s(second)
      [second/3600, second/60 % 60, second % 60].map{|t| t.to_s.rjust(2,'0')}.join(':')
    end


    # Информация о видео файле
    def ffmpeg_context(video_file)
      FFMpeg::AVFormatContext.new(video_file)
    end
    def get_video_info(video_file)
      video_context = ffmpeg_context(video_file)
      video_codec = []
      audio_codec = []

      video_context.codec_contexts.each_with_index { |ctx,i|
        case FFMpeg::MAP_CODEC_TYPES[ctx.codec_type]
        when /video/i
          video_codec << { :name => ctx.name, :long_name => ctx.long_name, :width => ctx.width, :height => ctx.height }
        when /audio/i
          audio_codec << { :name => ctx.name, :long_name => ctx.long_name,
                           :audio_channels => ctx.channels, :audio_sample_rate =>ctx.sample_rate }
        end
      }

      {
        :file_name   => "'#{File.basename(video_file)}'",
        :file_size   => ApplicationController.helpers.number_to_human_size(File.size(video_file)),
        :duration    => second_to_s(video_context.duration/1000000),
        :resolution  => (!video_codec.blank? ? ("#{video_codec.first[:width]}x#{video_codec.first[:height]}") : ""),
        :audio_codec => (!video_codec.blank? ? ("#{video_codec.first[:long_name]}") : ""),
        :video_codec => (!audio_codec.blank? ? ("#{audio_codec.first[:long_name]}") : "")
      }

    end

    # Parses a "WxH" formatted string, where W is the width and H is the height.
    def parse string
      if match = (string && string.match(/\b(\d*)x?(\d*)\b([\>\<\#\@\%^!])?/i))
        match[1,2]
      end
    end

  end
end


# Task.last.process_of_generation_screen_list
