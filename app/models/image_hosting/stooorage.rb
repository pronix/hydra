class ImageHosting::Stooorage < ImageHosting
  base_uri "www.stooorage.com"

  class << self
    def get_cookeis
       get "/"
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

        self.default_cookies.add_cookies(get_cookeis.headers["set-cookie"][0])
        response = HTTParty.post "http://www.stooorage.com/", {
          :body => form.read,
          :headers => {
            'Content-Length' => form.length.to_s,
            'Content-Type' => "multipart/form-data; boundary=#{boundary}",
            'Accept-Language' =>	'en-us,en;q=0.5' }
        }

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

        # file_path, file_name, content_type  = "/home/maxim/www/hydra/data/screen/attachments/43/original.png",
        # "193_tableless_model.png"
