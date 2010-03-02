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
            case upload_images_profile.host
            when Common::Host::IMAGEVENUE
              log "start job:uploading IMAGEVENUE "
              log "IMAGEVENUE upload file #{task_cover.cover.attachment.original_filename}"
              task_cover.links = ImageHosting::Imagevenue.send_image(_options)
              task_cover.save
              log "stop job:uploading IMAGEVENUE "
            when Common::Host::IMAGEBAM
              log "start job:uploading IMAGEBAM "
              log "IMAGEBAM upload file #{task_cover.cover.attachment.original_filename}"
              task_cover.links = ImageHosting::Imagebam.send_image(_options)
              task_cover.save
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
