class ImageHosting::Pixhost < ImageHosting
  base_uri "www.pixhost.org"

  # Supported formats: gif, png, jpg.
  #  Maximum image size is 5 MB.
  class << self
    def get_cookeis
       get "/classic-upload"
    end

    def send_image(args)
      file_path, file_name, content_type  =
        args[:file_path], args[:file_name], args[:content_type]
      type_file = `file -b '#{file_path}'`
      unless type_file[/png|gif|jpg|jpeg/i]
        raise ImageHostingNotSupportError, "Not support format image"
      end
      if File.size(file_path) > 5.megabytes
        raise ImageHostingNotSupportError, "Big image"
      end

      begin
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
        form << "name=\"tos\"; "
        form << "\r\n\r\n"
        form << "on"
        form << "\r\n"

        form << "--" << boundary << "\r\n"
        form << "Content-Disposition: form-data; "
        form << "name=\"img[]\"; "
        form << "filename=\"#{file_name}\"; "
        form << "Content-Type: \"#{Rack::Mime.mime_type(File.extname(file_path))}\""
        form << "\r\n\r\n"
        form << File.read(file_path)
        form << "\r\n--" << boundary << "--\r\n"
        form.seek(0)
        self.default_cookies.add_cookies(get_cookeis.headers["set-cookie"][0])
        response = post "/classic-upload",{ :body => form.read,
          :headers => {
            'Content-Length' => form.length.to_s,
            'Content-Type' => "multipart/form-data; boundary=#{boundary}" } }

      rescue
        raise ImageHostingServiceAvailableError
      end


      begin
        doc = Nokogiri.parse(response)
        result = doc.css(".links").map {|x|
          [x.css("div:first").text.strip, x.css("div:last").css("input").attr("value").to_s.strip ]}

        raise ImageHostingLinksError  if result.blank?
      rescue
        raise ImageHostingLinksError
      end

      form.close
      return result
    rescue => ex
      form.close
      raise ex
    end
  end
end
        # file_path, file_name, content_type  = "/home/maxim/www/hydra/data/screen/attachments/43/original.png",
        # "193_tableless_model.png", 0
