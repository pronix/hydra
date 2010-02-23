require 'net/ftp'
module Job
  module Uploading

    def process_uploading
      # Загрузка полученный файлов на mediavalise
      if mediavalise?
        Rails.logger.info " [ job:uploading mediavalise ] start - #{Time.now.to_s}"
        _host, _login, _password = mediavalise_profile.host, mediavalise_profile.login, mediavalise_profile.password
        _files = Dir.glob(uploading_path + "**/**")
        !_files.blank? && Net::FTP.open(_host, _login, _password) do |ftp|
          _files.each { |x| ftp.putbinaryfile(x, File.basename(x)) }
        end
        Rails.logger.info " [ job:uploading mediavalise ] stop - #{Time.now.to_s}"
      end

      # Загрузка скрин листов на imagehosting
      if upload_images?
        _options = {
          :login => upload_images_profile.login,
          :password => upload_images_profile.password,
          :content_type => upload_images_profile.content_type_id
        }
        links_image_hosting =
          case upload_images_profile.host
          when Common::Host::IMAGEVENUE
            Rails.logger.info " [ job:uploading IMAGEVENUE ] start - #{Time.now.to_s}"
            Dir.glob(screen_list_path + "**/**").each do |file|
            ImageHosting::Imagevenue.send_image(_options.merge({ :file_path => file}))
            Rails.logger.info " [ job:uploading IMAGEVENUE ] stop - #{Time.now.to_s}"
          end
          end
      end


      job_completion!
    rescue => ex
      erroneous!(ex.message)
    end

  end
end

