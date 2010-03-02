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
            case upload_images_profile.host
            when Common::Host::IMAGEVENUE
              log "start job:uploading IMAGEVENUE "
              log "IMAGEVENUE upload file #{sc.screen.attachment.original_filename}"
              sc.links = ImageHosting::Imagevenue.send_image(_options)
              sc.save
              log "stop job:uploading IMAGEVENUE "
            when Common::Host::IMAGEBAM
              log "start job:uploading IMAGEBAM "
              log "IMAGEBAM upload file #{sc.screen.attachment.original_filename}"
              sc.links = ImageHosting::Imagebam.send_image(_options)
              sc.save
              log "stop job:uploading IMAGEBAM "
            end
          end
        rescue => ex
          raise " #{upload_images_profile.host} : #{ex.message}"
        end
      end
    end

  end
end
