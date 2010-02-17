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
        Open3.popen3("file -i #{video_file}") {|i,o,e| type_file =  o.gets }



        if !type_file.blank? && Common::Video.mime_type.include?(type_file.scan(/video\/\w+/).first)

          FileUtils.rm_rf(@path_tmp) # удаляем сриншоты с придыдущего видео файла
          FileUtils.mkdir_p(@path_tmp)

          # Делаем скриншоты с видео файла
          file_info = FFMpeg::AVFormatContext.new(_video_file)
          duration_file = file_info.duration
          delta = duration_file/@number_of_frames

          (1).upto(@number_of_frames) do |i|
            tc = ((delta*i -1000)/1000000)
            tc = tc-100 if (duration_file/1000000) <= tc
            out_file = File.join(@path_tmp, "#{File.basename(video_file)}_#{i}.#{@macro.file_format}" )
            out_files << {:file => out_file, :timestamp => tc }
            command = "ffmpeg -i #{video_file}  -an -ss #{tc} -vframes 1 -y #{out_file}"
            # raise "ffmpeg error" unless
            output = `#{command}`
          end


# Template
# Font – Выбор шрифта (ниспадающий список) (для header text и временного штампа)
# *Необходимая вещь
# Font size – размер шрифта
# Font color – цвет шрифта (http://www.eyecon.ro/colorpicker/)

# Header text – текст расположенный в хидере скринлиста, с поддержкой ниже указанных макросов
# Текстовое поле, с произвольным указанием макросов
# Доступные макросы(размещение в текстовом поле):
# File name: [file_name]
# Resolution: [width]x[height] – параметр, указывающий ширину и высоту видеокадра
# Duration: [duration_time] – общее время ролика
# File size: [file_size] – размер файла (ролика)
# Video codec: [video_codec]
# Audio codec: [audio_codec]

# Add timestamp – добавление временного штампа на каждое превью внизу (Выбор Да либо Нет)
# Позиционирование: Left, Right

# Add logo – добавить логотип (выбор из списка)


          # Собираем сделанные скриншоты в один скрин лист
          #<Macros id: 28, name: "maiores", user_id: 718075439,
          # number_of_frames: 20, columns: 20, - кол-во картинок и колонок
          # thumb_width: 20, thumb_height: 20, thumb_quality: 40,
          # thumb_frame: true, frame_size: 2, frame_color: "#FFDDEE",
          # thumb_shadow: true, thumb_padding: "2px 7px 2px 1",
          # font: "Arial", font_size: 24, font_color: "#EEFFDD",
          # template_background: "#FFFFEE", header_text: "Movie",
          # add_timestamp: true,
          # position_timestamp: "right",
          # add_logo: false, logo_id: nil, file_format: "png", created_at: "2010-02-13 00:01:51", updated_at: nil>


          @font_settings = []
          @font_settings << " -font '#{@macro.font}'" unless @macro.font.blank?
          @font_settings << " -pointsize '#{@macro.font_size}'" unless @macro.font_size.blank?
          @font_settings << " -fill '##{@macro.font_color}'" unless @macro.font_color.blank?
          @font_settings = @font_settings.join(' ')




          # Если в макросе указано что нужно добавить шкалу времени то добавляем ее
          @macro.add_timestamp? &&  out_files.map{|x|
            position = Common::PositionTimestamp::values[@macro.position_timestamp]
            time = x[:timestamp]
            text = [time/3600, time/60 % 60, time % 60].map{|t| t.to_s.rjust(2,'0')}.join(':')

            cmd = %(convert #{x[:file]} -gravity #{position} #{@font_settings} -draw "text 5,5 '#{text}'" #{x[:file]} )
            output = `#{cmd}`

          }

          # Расположение изображений
          @tile = %( -tile #{@macro.columns}x )
          # рамка
          @border = ""
          @border = %( -background #{@macro.frame_color} -frame #{@macro.frame_size} ) if @macro.thumb_frame?
          # качество
          @quality = %( -quality #{@macro.thumb_quality} )
          # тень
          @shadow = ""
          @shadow = %( -shadow ) if @macro.thumb_shadow?
          # Фон
          @background = ""
          @background = %( -background #{@macro.template_background} ) unless @macro.template_background.blank?

          # размеры картинок
          @thumb_padding = []
          @macro.thumb_padding.scan(/(?:|[+|-])\d+/) {|t|
            @thumb_padding << (t[/[+|-]/] ? t : "+#{t}") } unless @macro.thumb_padding.blank?
          @thumb_padding = [@thumb_padding.first, @thumb_padding.last].join

          @geometry = ""
          @scale = @macro.thumb_width > @macro.thumb_height ? "#{@macro.thumb_width}x" : "x#{@macro.thumb_height}"
          # @scale = "#{@macro.thumb_width}#{@macro.thumb_height}"
          # @scale_sumbol = @macro.thumb_width > @macro.thumb_height ? '>' : '<'
          @geometry = %(-geometry #{@scale}#{@thumb_padding} )


          @options = [@tile, @quality, @border, @shadow, @background, @geometry].join(' ')
          input_files = ""
          input_files = out_files.map{|x| x[:file] }.join(' ')

          out_file = File.join(@path, [File.basename(video_file), @macro.file_format].join('.') )

          montage_command = %(montage #{input_files} #{@options} #{out_file})
          puts "="*90
          puts montage_command
          puts "="*90
          output = `#{montage_command}`
          # удаляем сриншоты сделанные с видео файла
          # FileUtils.rm_rf(@path_tmp)

        end
      end

      end_job("Count files: #{Dir.glob(@path+ "**/**").size}")

    # rescue => ex
    #   end_job("Error:#{ex.message}")
    #   erroneous!
    #   start_job("Error:#{ex.message}")

    end

    private
    def escape_file_name(s)
      s.gsub(/[" "|\)|\(]/) {|x| "\\#{x}" }
    end
  end
end

