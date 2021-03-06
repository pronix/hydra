class ImageHosting::Imagebam < ImageHosting
  base_uri "www.imagebam.com"
# jpg, gif or png
  # Image is larger then 3mb.
  class << self

    def login(user, password)
      post "/login", { :body => { :nick => user, :pw => password, :dologin => true}}
    end

    def send_image(args=nil)
      file_path, file_name, user, password, content_type  =
        args[:file_path], args[:file_name], args[:login], args[:password], args[:content_type]

      type_file = `file -b '#{file_path}'`
      unless type_file[/png|gif|jpg|jpeg/i]
        raise ImageHostingNotSupportError, "Not support format image"
      end
      if File.size(file_path) > 3.megabytes
        raise ImageHostingNotSupportError, "Big image"
      end

      boundary = ActiveSupport::SecureRandom.hex.upcase
      form = Tempfile.new(boundary)

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
      file_to_post_param(form, "file[]", file_path, file_name)
      form << "\r\n--" << boundary << "--\r\n"
      form.seek(0)

      response_login = self.login(user, password)
      raise "[ IMAGEBAM ] Invalid login or password" unless response_login.body[/You are now logged in as/i]
      self.default_cookies.add_cookies([response_login.headers["set-cookie"]].flatten.first) if  response_login.headers["set-cookie"]

      begin
        response = post "/nav/save",{ :body => form.read,
          :headers => {
            'Content-Length' => form.length.to_s,
            'Content-Type' => "multipart/form-data; boundary=#{boundary}" } }

      rescue => ex
        raise ImageHostingServiceAvailableError
      end

      begin
        doc = Nokogiri.parse(response)
        Task.log '-'*90
        Task.log doc.to_s
        Task.log '-'*90
        result = []
        doc.css("fieldset").last.css("form").css("div").each_slice(2) {|m|
          result << [m.first.text.strip, m.last.css("input").attr("value").to_s.strip ] }
        raise ImageHostingLinksError  if result.blank?
      rescue
        raise ImageHostingLinksError
      end

      return result

    rescue => ex
      raise ex
    ensure
      form = nil
      GC.start
    end
  end
end
