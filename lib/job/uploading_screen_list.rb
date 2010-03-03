module Job
  module UploadingScreenList

    def screen_list_uploading

      if upload_images?
        begin
          !list_screens.blank? && list_screens.each do |sc|
            _options = {
              :login =>        upload_images_profile.login,
              :password =>     upload_images_profile.password,
              :content_type => upload_images_profile.content_type_id,
              :file_path=>     sc.screen.attachment.path,
              :file_name =>    sc.screen.attachment.original_filename
          }

            log "start job:uploading #{upload_images_profile.host} "
            log "#{upload_images_profile.host} upload file #{sc.screen.attachment.original_filename}"

            case upload_images_profile.host
            when Common::Host::IMAGEVENUE
              sc.links = ImageHosting::Imagevenue.send_image(_options)
            when Common::Host::IMAGEBAM
              sc.links = ImageHosting::Imagebam.send_image(_options)
            when Common::Host::STOOORAGE
              sc.links = ImageHosting::Stooorage.send_image(_options)
            when Common::Host::PIXHOST
              sc.links = ImageHosting::Pixhost.send_image(_options)
            end

            sc.save
            log "stop job:uploading #{upload_images_profile.host} "

          end

        rescue ImageHostingServiceAvailableError
          raise "сервис недоступен"
        rescue ImageHostingLinksError
          raise "невозможно получить ссылки на файлы (файлы, картинки)"

        rescue => ex
          raise " #{upload_images_profile.host} :  #{ex.message}"
        end
      end
    end

  end
end
