class Mediavalise
  include HTTParty
  base_uri "http://www.mediavalise.com"
# r = HTTParty.post('http://www.mediavalise.com/user_session',:query => { "user_session[login]" => 'serg', "user_session[password]" => 'mvpass'})

  class << self

    def login(user, password)
      HTTParty.post('http://www.mediavalise.com/user_session',
                    :query => { "user_session[login]" => user.to_s,
                      "user_session[password]" => password.to_s})
    end

    def get_form
      response_login = self.login(user, password)
      raise "[MEDIAVALISE ] Invalid login or password" if response_login.body.to_s["error_full"]
      self.default_cookies.add_cookies(response_login.headers["set-cookie"][0])
      get('http://www.mediavalise.com/account/upload')
    end

    def uploading(args=nil)

      file_path, file_name, user, password, task =
        args[:file_path], args[:file_name], args[:login], args[:password], args[:task]

      response_login = self.login(user, password)
      raise "[MEDIAVALISE ] Invalid login or password" if response_login.body.to_s["error_full"]
      self.default_cookies.add_cookies(response_login.headers["set-cookie"][0])


      boundary = ActiveSupport::SecureRandom.hex.upcase
      form = Tempfile.new(boundary)



      authenticity_token = get_form
      authenticity_token = Nokogiri.parse(authenticity_token)
      authenticity_token = authenticity_token.css("input[name='authenticity_token']").attr('value').to_s rescue ''
      form << "--" << boundary << "\r\n"
      form << "Content-Disposition: form-data; "
      form << "name=\"authenticity_token\"; "
      form << "\r\n\r\n"
      form << authenticity_token
      form << "\r\n"

      form << "--" << boundary << "\r\n"
      form << "Content-Disposition: form-data; name=\"shared_file[file][]\"; "
      form << "filename=\"#{file_name}\"\r\n"
      form << "Content-Type: #{Rack::Mime.mime_type(File.extname(file_path))}\r\n"
      form << "Content-Transfer-Encoding: binary\r\n\r\n"
      form << File.open(file_path).binmode.read

      form << "\r\n--" << boundary << "--\r\n"
      form.seek(0)

      response = post("/files",{ :body => form.read,
        :headers => {
          'Content-Length' => form.length.to_s,
          'Content-Type' => "multipart/form-data; boundary=#{boundary}" } })

      doc = Nokogiri.parse(response)
      raise "[MEDIAVALISE ] Invalid server" unless response.code.to_i == 200
      _result = response.body.to_s.scan(/http:\/\/[a-zA-z0-9|.|\/]*\b/)
      _result.reject!{|x| x["delete"] }
      form.close
      task.log "links mediavalise : #{_result.join(', ')}"
      task.mediavalise_links = [task.mediavalise_links , _result.to_s.gsub(/\s+/, ' ').strip].compact.flatten.join(', ')
      task.save!
      return _result

    rescue => ex
      form.close
      raise "Error: uploading file to MediaValise: #{ex.message}"
    end

  end
end

