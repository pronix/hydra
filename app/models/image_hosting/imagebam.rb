class ImageHosting::Imagebam < ImageHosting
  base_uri "www.imagebam.com"

  class << self

    def login(user, password)
      post "/login", { :body => { :nick => user, :pw => password, :dologin => true}}
    end

    def send_image(args)
      file_path, file_name, user, password, content_type  =
        args[:file_path], args[:file_name], args[:login], args[:password], args[:content_type]

      boundary = ActiveSupport::SecureRandom.hex.upcase
      form = Tempfile.new(Time.now.to_s)

      form << "--" << boundary << "\r\n"
      form << "Content-Disposition: form-data; "
      form << "name=\"content_type\"; "
      form << "\r\n\r\n"
      form << (content_type == Common::ContentType::FAMILY ? "0" : "1")
      form << "\r\n"

      form << "--" << boundary << "\r\n"
      form << "Content-Disposition: form-data; "
      form << "name=\"thumb_size\"; "
      form << "\r\n\r\n"
      form << "0"
      form << "\r\n"

      form << "--" << boundary << "\r\n"
      form << "Content-Disposition: form-data; "
      form << "name=\"thumb_size\"; "
      form << "\r\n\r\n"
      form << "0"
      form << "\r\n"

      form << "--" << boundary << "\r\n"
      form << "Content-Disposition: form-data; "
      form << "name=\"thumb_align\"; "
      form << "\r\n\r\n"
      form << "1"
      form << "\r\n"


      form << "--" << boundary << "\r\n"
      form << "Content-Disposition: form-data; "
      form << "name=\"file[]\"; "
      form << "filename=\"#{file_name}\"; "
      form << "Content-Type: \"#{Rack::Mime.mime_type(File.extname(file_path))}\""
      form << "\r\n\r\n"
      form << File.read(file_path)
      form << "\r\n--" << boundary << "--\r\n"
      form.seek(0)

      response_login = self.login(user, password)
      raise "[ IMAGEBAM ] Invalid login or password" unless response_login.body[/You are now logged in as/i]
      self.default_cookies.add_cookies(response_login.headers["set-cookie"][0])

      response = post "/nav/save",{ :body => form.read,
        :headers => {
          'Content-Length' => form.length.to_s,
          'Content-Type' => "multipart/form-data; boundary=#{boundary}" } }
      doc = Nokogiri.parse(response)

      result = []
      doc.css("fieldset").last.css("form").css("div").each_slice(2) {|m|
        result << [m.first.text.strip, m.last.css("input").attr("value").to_s.strip ] }

      return result

    rescue => ex
      raise "Uploading image to Imagebam: #{ex.message}"
    ensure
      form.close
    end
  end
end