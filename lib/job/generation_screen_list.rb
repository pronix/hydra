require 'open3'
require 'ffmpeg-ruby'
class JobGenerationScreenListError < StandardError #:nodoc:
end

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

    # обычная генерация
    def process_of_generation_screen_list
      _generation_screen_list
      job_completion!("Count files: #{Dir.glob(screen_list_path+ "**/**").size}")

    rescue JobGenerationScreenListError => ex
      log ex.message, :error
      erroneous!("#{ex.message}")
    rescue => ex
      log ex.message, :error
      erroneous!("Generation screen list:  Unknow error")
    end

    # повторная генерация запусщенная в ручную
    def re_process_of_generation_screen_list
      _generation_screen_list
      finish_regenerate!("Count files: #{Dir.glob(screen_list_path+ "**/**").size}")
    rescue JobGenerationScreenListError => ex
      log ex.message, :error
      erroneous!("#{ex.message}")
    rescue => ex
      log ex.message, :error
      erroneous!("Generation screen list: Unknow error")
    end

    private

    def _generation_screen_list
      @macro = screen_list_macro
      @number_of_frames = @macro.number_of_frames
      list_screens.destroy_all # удаляем скринлисты сгенерированные в прошлый раз

      @path = screen_list_path
      @path_tmp = File.join(screen_list_path, 'tmp')
      FileUtils.rm_rf(@path)
      FileUtils.mkdir_p(@path)


      Dir.glob(unpacked_path + "**/**").each do |_video_file|
        video_file = escape_file_name(_video_file)

        type_file = nil
        err = nil
        out_files = []
        Open3.popen3("file -i '#{video_file}'") {|i,o,e| type_file =  o.gets }



        if !type_file.blank? && Common::Video.mime_type.include?(type_file.split(':').last.scan(/[a-zA-Z0-9-]+\/[a-zA-Z0-9-]+/).first)

          FileUtils.rm_rf(@path_tmp) # удаляем сриншоты с придыдущего видео файла
          FileUtils.mkdir_p(@path_tmp)

          # Делаем скриншоты с видео файла
          file_info = ffmpeg_context(video_file)

          duration_file = duration(video_file)
          duration_file = file_info.duration unless duration_file.to_i > 0
          file_info.close_file rescue nil

          delta = duration_file/@number_of_frames
          video_info = get_video_info(video_file)

          (1).upto(@number_of_frames) do |i|
            tc = delta*i
            tc = tc-100 if (duration_file) <= tc
            out_file = File.join(@path_tmp, "#{File.basename(video_file)}_#{i}.#{@macro.file_format}" )
            out_file_name = "#{File.basename(video_file)}_#{i}.#{@macro.file_format}"
            out_files << {:file => out_file, :timestamp => tc }

            @vo_format = @macro.file_format["jpg"] ? "jpeg" : "png"
            command = "mplayer -nosound  -frames 1 -ss #{tc} '#{video_file}' -loop 1 -vo #{@vo_format}:outdir=#{@path_tmp}/ && mv -f #{@path_tmp}/00000001.#{@macro.file_format} #{@path_tmp}/#{out_file_name}"
            log command
            output = `#{command}`
          end


          # Собираем сделанные скриншоты в один скрин лист

          @font_settings = []
          @font_color = /#?(.*)$/.match(@macro.font_color.to_s) && "##{$1}"
          @font_settings << " -font '#{@macro.font}'" unless @macro.font.blank?
          @font_settings << " -pointsize '#{@macro.font_size}'" unless @macro.font_size.blank?
          @font_settings << " -fill '#{@font_color}'" unless @macro.font_color.blank?
          @font_settings = @font_settings.join(' ')

          @font_settings_tm = [] # для временной шкалы чтоб для шапки и временной шкалы размер шрифта был разный
          @font_settings_tm << " -font '#{@macro.font}'" unless @macro.font.blank?
          @font_settings_tm << " -pointsize '#{@macro.font_size.to_i + 20}'" unless @macro.font_size.blank?
          @font_settings_tm << " -fill '#{@font_color}'" unless @macro.font_color.blank?
          @font_settings_tm = @font_settings_tm.join(' ')

          # Если в макросе указано что нужно добавить шкалу времени то добавляем ее
          @macro.add_timestamp? &&  out_files.map{|x|
            position = Common::PositionTimestamp::values[@macro.position_timestamp]
            text = second_to_s(x[:timestamp])
            cmd = %(convert '#{x[:file]}' -gravity #{position} #{@font_settings_tm} -draw "text 5,5 '#{text}'" '#{x[:file]}' )
            output = `#{cmd}`

          }

          # Расположение изображений
          @tile = %( -tile '#{@macro.columns}x' )
          # рамка
          @border = ""
          @frame_color = /#?(.*)$/.match(@macro.frame_color.to_s) && "##{$1}"
          # @border = %( -bordercolor '#{@frame_color}' -frame '#{@macro.frame_size}' ) if @macro.thumb_frame?
          @border = %( -frame '#{@macro.frame_size}' -mattecolor '#{@frame_color}' ) if @macro.thumb_frame?

          # качество
          @quality = %( -quality '#{@macro.thumb_quality}' )
          # тень
          @shadow = ""
          @shadow = %( -shadow ) if @macro.thumb_shadow?
          # Фон
          @background = ""
          @template_background = /#?(.*)$/.match(@macro.template_background.to_s) && "##{$1}"
          @background = %( -background '#{@template_background}' ) unless @template_background.blank?

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
          out_file = File.join(@path, [File.basename(video_file, File.extname(video_file)), @macro.file_format ].join('.') )
          montage_command = %( montage #{input_files} #{@options} '#{out_file}')
          log montage_command
          output=`#{montage_command}`


          # Подготовляем технические данные для заголовка
          @header_text = @macro.header_text.chomp.
            gsub(/\[file_name\]/,        video_info[:file_name]).
            gsub(/\[width\]x\[height\]/, video_info[:resolution]).
            gsub(/\[duration_time\]/,    video_info[:duration]).
            gsub(/\[file_size\]/,        video_info[:file_size]).
            gsub(/\[video_codec\]/,      video_info[:video_codec]).
            gsub(/\[audio_codec\]/,      video_info[:audio_codec])

          # Добавляем шапку для логотипа
            @tmp_logo = File.join(@path, ["tmp_logo", @macro.file_format].join('.') )

            unless File.exist? @tmp_logo # создаем только один раз

              if @macro.add_logo? && !@macro.logo.blank?
                @logo = @macro.logo.attachment.path
              end

              @size_screen = parse(`identify -format '%wx%h' '#{out_file}'`)
              # Создаем шаблон логотипа
              height_header = @macro.add_logo? ? '200' : "#{@header_text.split("\n").size * @macro.font_size.to_i * 1.34 }" # высота шапки
              command = [" convert ",
                      " -size '#{@size_screen.first}x#{height_header}' xc:#{!@background.blank? ? @background.split(' ').last : "none"} ",
                      " -gravity 'East' "]
              command << " -draw \" image over 10,0 0,0 '#{@logo}' \" " if @macro.add_logo? && !@macro.logo.blank?
              command << " '#{@tmp_logo}'  "

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

          # end add logo

          # Добавляем заголовок с техническими данными

          command = ["convert", "'#{out_file}'", "#{@font_settings}",
                     "-gravity 'NorthWest'", " -annotate +15+15 \"#{@header_text}\"",
                     " '#{out_file}' "].join(' ')
          log "add info"
          log command
          output = `#{command}`
        end
        video_info = nil
      end

      # Удаляем временные файлы
      FileUtils.rm_rf(@path_tmp) unless @path_tmp.blank?
      FileUtils.rm_rf(@tmp_logo) unless @tmp_logo.blank?

      # Если получилось несколько скрин листов то объеденяем их в один
      _files = Dir.glob(@path + "**/**")
      if _files.size > 1
        _new_file_name = File.basename(_files.first)
        _result_file = File.join(File.dirname(_files.first),ActiveSupport::SecureRandom.hex.upcase)
        cmd = "convert #{ _files.map{ |x| "'#{x}'" }.join(' ') } -append '#{_result_file}'"
        `#{cmd}`
        log "append scren list: #{cmd}" if $?.exitstatus != 0
        _files.each { |x| FileUtils.rm_r(x) }
        ` mv '#{_result_file}' '#{File.join(File.dirname(_result_file), _new_file_name)}'`
      end

      Dir.glob(@path + "**/**").each do |ff|
        list_screens.build :screen => Screen.create!(:attachment => File.open(ff))
        save
      end
    ensure
      command = nil
      _files = nil
      output = nil
      file_info = nil
      GC.start
    end




    def escape_file_name(s)
      s.to_s.gsub(/\\|\n|\r/, '').gsub(/\s+/, " ")
    end

    def second_to_s(second)
      "%02d:%02d:%02d" % [second/3600,(second/60 % 60),(second % 60)]
    end


    # Информация о видео файле
    def ffmpeg_context(video_file)
      FFMpeg::AVFormatContext.new(video_file)
    end
    def duration(v_file)
      _duration = `mplayer -identify #{v_file} -nosound -vc dummy -vo null`
      _duration[/ID_LENGTH=(.+)/] && $1.to_f
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

      duration = `mplayer -identify #{video_file} -nosound -vc dummy -vo null`
      duration = duration[/ID_LENGTH=(.+)/] && $1.to_f
      duration = (video_context.duration/1000000) unless duration.to_i > 0
      video_context.close_file rescue nil
      video_context = nil
      {
        :file_name   => "'#{File.basename(video_file)}'",
        :file_size   => ApplicationController.helpers.number_to_human_size(File.size(video_file)),
        :duration    =>  second_to_s(duration), #second_to_s(video_context.duration/1000000),
        :resolution  => (!video_codec.blank? ? ("#{video_codec.first[:width]}x#{video_codec.first[:height]}") : ""),
        :video_codec => (!video_codec.blank? ? ("#{video_codec.first[:long_name]}") : ""),
        :audio_codec => (!audio_codec.blank? ? ("#{audio_codec.first[:long_name]}") : "")
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
