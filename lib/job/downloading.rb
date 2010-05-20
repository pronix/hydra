module Job
  module Downloading
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Скачивание фалов
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    # Создаем путь к файлам и отправляем файлы на скачивание
    def to_aria
      @proxies = user.proxies.online.map{ |x| { :free => true , :address => x.address }} if proxy?
      @path = downloding_path

      FileUtils.mkdir_p(File.dirname(@path))
      __options={ "dir" => @path }

      # Поставили все файлы в  очередь
      self.extract_link.each do |uri|
        _options = if proxy? && !@proxies.blank?
                     _i = @proxies.find{ |x| x[:free] }
                     unless _i
                       _i = @proxies.map{ |x| x[:free] = true} && @proxies.first
                     end
                     _i[:free] = false
                     __options.merge({ "http-proxy" => _i[:address] })
                   else
                     __options
                   end
        downloading_files.create(:uri => uri, :options => _options )
      end
      downloading_files.last.start! # стартуем закачку для одного файла
    end

    # Проверка загружены ли все файлы по задаче
    def check_downloading
      if downloading_files.all?{|x| x.complete? }
        write_attribute(:percentage, 100)
        write_attribute(:speed, (downloading_files.sum(:speed)/ downloading_files.count)/1.kilobyte )
        completion_downloading!("Count files: #{downloading_files.count}") if downloading?
      elsif downloading_files.any?{|x| x.error? }
        erroneous! "Error: #{downloading_files.error.first.comment}"
      end

      # Aria2cRcp.purge # очищаем aria2c от уже завершенных задач
    end


  end
end
