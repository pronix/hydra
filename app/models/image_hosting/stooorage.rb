class ImageHosting::Stooorage < ImageHosting
  base_uri "www.stooorage.com"

  class << self
    def get_cookeis
       get "/"
    end
    def send_image(args = nil)
      begin
        file_path, file_name  =  args[:file_path], args[:file_name]
        boundary = ActiveSupport::SecureRandom.hex.upcase

        form = Tempfile.new(boundary)
        form << "--" << boundary << "\r\n"
        form << "Content-Disposition: form-data; "
        form << "name=\"img\"; "
        form << "filename=\"#{file_name}\" "
        form << "Content-Type: \"#{Rack::Mime.mime_type(File.extname(file_path))}\""
        form << "\r\n\r\n"
        form << File.read(file_path)
        form << "\r\n--" << boundary << "--\r\n"
        form.seek(0)

        self.default_cookies.add_cookies(get_cookeis.headers["set-cookie"][0])
        response = post "/",{ :body => form.read,
          :headers => {
            'Content-Length' => form.length.to_s,
            'Content-Type' => "multipart/form-data; boundary=#{boundary}",
          } }

      rescue
        raise ImageHostingServiceAvailableError
      end

      begin
        doc = Nokogiri.parse(response)
        result = doc.css("div.links").map {|x|
          [x.css("div").first.text.strip,
           x.css("div:last").css("input").attr("value").to_s.strip] }

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

