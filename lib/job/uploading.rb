require 'net/ftp'
module Job
  module Uploading

    def process_uploading

      # Загрузка полученный файлов на mediavalise
      if mediavalise?
        begin
          log "start job:uploading mediavalise "
          _host, _login, _password = mediavalise_profile.host, mediavalise_profile.login, mediavalise_profile.password
          _files = Dir.glob(uploading_path + "**/**")
          !_files.blank? && Net::FTP.open(_host, _login, _password) do |ftp|
            _files.each { |x| ftp.putbinaryfile(x, File.basename(x)) }
          end
          log "stop job:uploading mediavalise "
        rescue => ex
          log " MEDIAVALISE : #{ex.message}", :debug
          raise " MEDIAVALISE : #{ex.message}"
        end
      end

      # Загрузка скрин листов на imagehosting
      if upload_images?
        begin


          !list_screens.blank? && list_screens.each do |sc|
          _options = {
              :login => upload_images_profile.login,
              :password => upload_images_profile.password,
              :content_type => upload_images_profile.content_type_id,
              :file_path=> sc.screen.attachment.path,
              :file_name => sc.screen.attachment.original_filename
          }
            case upload_images_profile.host
            when Common::Host::IMAGEVENUE
              log "start job:uploading IMAGEVENUE "
              log "IMAGEVENUE upload file #{sc.screen.attachment.original_filename}"
              sc.links = ImageHosting::Imagevenue.send_image(_options)
              sc.save
              log "stop job:uploading IMAGEVENUE "
            when Common::Host::IMAGEBAM
              log "start job:uploading IMAGEVENUE "
              log "IMAGEVENUE upload file #{sc.screen.attachment.original_filename}"
              sc.links = ImageHosting::Imagebam.send_image(_options)
              sc.save
              log "stop job:uploading IMAGEVENUE "
          end
          end
        rescue => ex
          raise " #{upload_images_profile.host} : #{ex.message}"
        end
      end


      job_completion!
    rescue => ex
      erroneous!(ex.message)
    end

  end
end

