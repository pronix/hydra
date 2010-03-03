module Job
  module UploadingCovers

    def covers_uploading
      if upload_images?
        begin

          !task_covers.blank? && task_covers.each do |task_cover|
          _options = {
              :login =>        upload_images_profile.login,
              :password =>     upload_images_profile.password,
              :content_type => upload_images_profile.content_type_id,
              :file_path=>     task_cover.cover.attachment.path,
              :file_name =>    task_cover.cover.attachment.original_filename
          }

            log "start job:uploading #{upload_images_profile.host} "
            log "#{upload_images_profile.host} upload file #{task_cover.cover.attachment.original_filename}"

            case upload_images_profile.host
            when Common::Host::IMAGEVENUE
              task_cover.links = ImageHosting::Imagevenue.send_image(_options)
            when Common::Host::IMAGEBAM
              task_cover.links = ImageHosting::Imagebam.send_image(_options)
            when Common::Host::STOOORAGE
              task_cover.links = ImageHosting::Stooorage.send_image(_options)
            when Common::Host::PIXHOST
              task_cover.links = ImageHosting::Pixhost.send_image(_options)
            end
            task_cover.save

            log "stop job:uploading IMAGEVENUE "
          end

        rescue ImageHostingServiceAvailableError
          raise "сервис недоступен"
        rescue ImageHostingLinksError
          raise "невозможно получить ссылки на файлы (файлы, картинки)"
        rescue => ex
          raise " #{upload_images_profile.host} : #{ex.message}"
        end
      end
    end

  end
end
