module Job
  module Downloading
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Скачивание фалов
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    # Создаем путь к файлам и отправляем файлы на скачивание
    def to_aria
      @proxies = user.proxies.online.map{ |x| { :free => true , :address => x.address }} if proxy?
       # options["http-proxy"]=val
      @path = downloding_path

      FileUtils.mkdir_p(File.dirname(@path))
      @options={ "dir" => @path }

      self.extract_link.each do |uri|
        _options = if proxy? && !@proxies.blank?
                     _i = @proxies.find{ |x| x[:free] }
                     unless _i
                       _i = @proxies.map{ |x| x[:free] = true} && @proxies.first
                     end
                     _i[:free] = false
                     @options.merge({ "http-proxy" => _i[:address] })
                   else
                     @options
                   end
        @gid = Aria2cRcp.add_uri([uri], _options)
        downloading_files.create(:gid => @gid) if @gid
      end
    end

    # Проверка загружены ли все файлы по задаче
    def check_downloading
      if downloading_files.all?{|x| x.complete? }
        end_job("Count files: #{downloading_files.count}")
        write_attribute(:percentage, 100)
        write_attribute(:speed, (downloading_files.sum(:speed)/ downloading_files.count)/1.kilobyte )
        save
        downloading_files.destroy_all
        start_extracting!
        job_loggings.create(:job => "extracting", :startup => Time.now.to_s(:db) )
      elsif downloading_files.any?{|x| x.error? }
        end_job("Error: #{downloading_files.error.first.comment}")
        erroneous!
        start_job("Error: #{downloading_files.error.first.comment}")
      end
    end


  end
end
