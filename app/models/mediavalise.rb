class Mediavalise
  include HTTParty
  base_uri "hadoop.adenin.ru"

  class << self

    def login(user, password)
      post "/user_session", { :body =>
        { "user_session[login]" => user, "user_session[password]" => password}}
    end
    def uploading(args=nil)
      file_path, file_name, user, password =
        args[:file_path], args[:file_name], args[:login], args[:password]

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
      doc = Nokogiri.parse(response)

      # result = []
      # doc.css("fieldset").last.css("form").css("div").each_slice(2) {|m|
      # result << [m.first.text.strip, m.last.css("input").attr("value").to_s.strip ] }
      return response

    rescue => ex
      raise "Uploading file to MediaValise: #{ex.message}"
    ensure
      form.close
    end

  end
end
# <div id="file_links">
# <div>
# <h2 id="h2_file_name">203_routing_in_rails_3.mov</h2>
# <label>Download:</label>
# <input value="http://hadoop.adenin.ru/file/5a5unccvzfujzgrz/203_routing_in_rails_3.mov" id="download_link" type="text">
# <label>Delete</label>
# <input value="http://hadoop.adenin.ru/file/delete/28/mqtbxhav2tus7yuxxmjb4qt37jx6pepv" id="destroy_link" type="text">
# </div>
