# TODO что то не работает отправка изоражений
class ImageHosting::Imagevenue < ImageHosting
  base_uri 'users.imagevenue.com'
  def provider_class
    self.class
  end
 #  Image Types Allowed: jpeg, jpg
 # maximum file size: 3 Megs

  class << self
    def description
      %(
         Image Types Allowed: jpeg, jpg
          maximum file size: 3 Megs
       )
    end


    def login(user, password)
      post "/process_logon.php", {
        :body=> { :user => user, :password => password, :action => 1}
      }
    end
    def send_image(args)
      file_path, file_name, user, password, content_type  =
        args[:file_path], args[:file_name], args[:login], args[:password], args[:content_type]

      type_file = `file -b '#{file_path}'`
      unless type_file[/jpg|jpeg/i]
        raise ImageHostingNotSupportError, "Not support format image"
      end
      if File.size(file_path) > 3.megabytes
        raise ImageHostingNotSupportError, "Big image"
      end

      boundary = ActiveSupport::SecureRandom.hex.upcase
      form = Tempfile.new(boundary)
      form << "--" << boundary << "\r\n"
      form << "Content-Disposition: form-data; "
      form << "name=\"imgcontent\"; "
      form << "\r\n\r\n"
      form << (content_type == Common::ContentType::FAMILY ? "safe" : "notsafe")
      form << "\r\n"
      form << "--" << boundary << "\r\n"
      file_to_post_param(form, "userfile[]", file_path, file_name)
      form << "\r\n--" << boundary << "--\r\n"
      form.seek(0)

      response_login = self.login(user, password)
      raise "[ IMAGEVENUE ] Invalid login or password" if response_login.body[/You specified the wrong user name password combination/i]

      self.default_cookies.add_cookies([response_login.headers["set-cookie"]].flatten.first) if  response_login.headers["set-cookie"]

      begin
        response = post "/upload.php",{ :body => form.read,
          :timeout => 60.seconds,
          :headers => {
            'Content-Length' => form.length.to_s,
            'Content-Type' => "multipart/form-data; boundary=#{boundary}" } }
      rescue
        raise ImageHostingServiceAvailableError
      ensure
        form = nil
        GC.start
      end

      begin
        doc = Nokogiri.parse(response)
        result = []

        # result =  doc.css("form").map { |x| [ x.inner_html.split("<br>").first, x.css("textarea").inner_html ] }
        # Первая форма
        result << [
                   doc.css("form[@name='form1']").inner_html.split("<br>").first.strip,
                   doc.css("form[@name='form1'] textarea").inner_html
                  ]

        # Вторая форма
        result << [
                   doc.css("form[@name='form2']").text.split('.').first,
                   doc.css("form[@name='form2'] textarea").inner_html
                  ]

        # Третья форма
        result << [ "", doc.css("form[@name='form3'] textarea").inner_html ]

        # Четвертая форма
        result << [
                   doc.css("form[@name='form4']").inner_html.split("<br>").first.strip,
                   doc.css("form[@name='form4'] textarea").inner_html
                  ]

      rescue
        raise ImageHostingLinksError
      end

      return result

    rescue => ex
      raise ex
    end

  end

end
