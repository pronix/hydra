module Job
  module UploadingToMediavalise
    def mediavalise_uploading
      if mediavalise?
        begin
          log "start job:uploading mediavalise "
          _host, _login, _password = mediavalise_profile.host, mediavalise_profile.login, mediavalise_profile.password
          _files = Dir.glob(uploading_path + "**/**")
          for x in _files
            Mediavalise.uploading({ :file_path => x,
                                    :file_name => File.basename(x),
                                    :login => _login,
                                    :password => _password, :task => self })
          end

          log "stop job:uploading mediavalise "
        rescue => ex
          log " MEDIAVALISE : #{ex.message}", :debug
          raise " MEDIAVALISE : #{ex.message}"
        end

      end
    end
  end
end
