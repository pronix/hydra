module Job
  module UploadingToMediavalise
    def mediavalise_uploading
      if mediavalise?
        begin
          log "start job:uploading mediavalise "
          _host, _login, _password = mediavalise_profile.host, mediavalise_profile.login, mediavalise_profile.password
          _files = Dir.glob(uploading_path + "**/**")
          result  = []
          _files.each { |x|
            result << Mediavalise.uploading({ :file_path => x,
                                              :file_name => File.basename(x),
                                              :login => _login,
                                              :password => _password})
          }
          mediavalise_links = result.join(', ')
          save
          log "stop job:uploading mediavalise "
        rescue => ex
          log " MEDIAVALISE : #{ex.message}", :debug
          raise " MEDIAVALISE : #{ex.message}"
        end

      end
    end
  end
end


# if mediavalise?
#         begin
#           log "start job:uploading mediavalise "
#           _host, _login, _password = mediavalise_profile.host, mediavalise_profile.login, mediavalise_profile.password
#           _files = Dir.glob(uploading_path + "**/**")
#           !_files.blank? && Net::FTP.open(_host, _login, _password) do |ftp|
#             _files.each { |x| ftp.putbinaryfile(x, File.basename(x)) }
#           end
#           log "stop job:uploading mediavalise "
#         rescue => ex
#           log " MEDIAVALISE : #{ex.message}", :debug
#           raise " MEDIAVALISE : #{ex.message}"
#         end
#       end
