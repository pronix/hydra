class ImageHosting::Stooorage < ImageHosting
  base_uri "www.stooorage.com"

  class << self
    def get_cookeis
      response_get = get('/')
      self.default_cookies.add_cookies([response_get.headers["set-cookie"]].flatten.first) if  response_get.headers["set-cookie"]
    end

    # Picture is larger than 2 MBWrong file format, allowed are gif,png,jpgArray
    def send_image(args)

      file_path, file_name  =  args[:file_path], args[:file_name]
      type_file = `file -b '#{file_path}'`
      unless type_file[/png|gif|jpg|jpeg/i]
        raise ImageHostingNotSupportError, "Not support format image"
      end
      if File.size(file_path) > 2.megabytes
        raise ImageHostingNotSupportError, "Big image"
      end

      begin
        boundary = ActiveSupport::SecureRandom.hex.upcase

        form = Tempfile.new(boundary)
        form << "--" << boundary << "\r\n"
        file_to_post_param(form, "img", file_path, file_name)
        form << "\r\n--" << boundary << "--\r\n"
        form.seek(0)
        get_cookeis
        response = HTTParty.post "http://www.stooorage.com/", {
          :body => form.read,
          :headers => {
            'Content-Length' => form.length.to_s,
            'Content-Type' => "multipart/form-data; boundary=#{boundary}",
            'Accept-Language' =>	'en-us,en;q=0.5' }
        }

      rescue
        raise ImageHostingServiceAvailableError
      ensure
        form.close
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

      return result

    rescue => ex
      raise ex
    end
  end
end


