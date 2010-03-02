class Mediavalise
  include HTTParty
  base_uri "hadoop.adenin.ru"

  class << self

    def login(user, password)
      post "/user_session", { :body =>
        { "user_session[login]" => user, "user_session[password]" => password}}
    end
    def uploading(args=nil)
      file_path, file_name, user, password, task =
        args[:file_path], args[:file_name], args[:login], args[:password], args[:task]

      boundary = ActiveSupport::SecureRandom.hex.upcase
      form = Tempfile.new(boundary)


      form << "--" << boundary << "\r\n"
      form << "Content-Disposition: form-data; "
      form << "name=\"shared_file[file][]\"; "
      form << "filename=\"#{file_name}\"; "
      form << "Content-Type: \"#{Rack::Mime.mime_type(File.extname(file_path))}\""
      form << "\r\n\r\n"
      form << File.read(file_path)
      form << "\r\n--" << boundary << "--\r\n"
      form.seek(0)


      response_login = self.login(user, password)
      raise "[MEDIAVALISE ] Invalid login or password" if response_login.body.to_s["error_full"]
      self.default_cookies.add_cookies(response_login.headers["set-cookie"][0])

      response = post "/files",{ :body => form.read,
        :headers => {
          'Content-Length' => form.length.to_s,
          'Content-Type' => "multipart/form-data; boundary=#{boundary}" } }

      _result = response.body.to_s.scan(/http:\/\/[a-zA-z0-9|.|\/]*\b/)
      _result.reject!{|x| x["delete"] }
      form.close
      task.log "links mediavalise : #{_result.join(', ')}"
      task.mediavalise_links = [task.mediavalise_links.to_s.strip, _result].flatten.join(', ')
      task.save!
      return _result

    rescue => ex
      form.close
      raise "Error: uploading file to MediaValise: #{ex.message}"
    end

  end
end

