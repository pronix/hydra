# Управление скачиванием файлов.

class Download
  def initialize(app)
    @app = app
  end



=begin rdoc
Скачивание файла экспорта.
=end
  def call(env)
    if env["PATH_INFO"][/\/assets/]
      begin
        request = Rack::Request.new(env)
        user = UserSession.find.try(:user)
        raise "not user" if user.blank?
        @link =  /\/assets\/(.+)$/.match(env["PATH_INFO"]).to_a.last
        @headers = {
          'X-Accel-Redirect' => "/internal_download/#{@link}",
          'Content-Type' => Rack::Mime.mime_type(File.extname((@link.split('?').first rescue @link ))),
          'Content-Length' => File.size(File.join(RAILS_ROOT, 'data', @link))

        }
        [200, @headers, "ok!"]
      rescue => ex
        log ex.message
        [405, {"Content-Type" => "text/html" }, ex.message ]
      end
    else

      @app.call(env)
    end
  end

  private

  def set_headers(file_link)
    {
      'Content-Length' => File.size(file_link.path),
      'Content-Disposition' => "attachment; filename=\"#{file_link.file_name}\"",
      'Content-Type' => file_link.mime_type.to_s,
    }
  end


  def log message
    Rails.logger.info [" [ Dwnload export file ] ", message].join
  end
end
