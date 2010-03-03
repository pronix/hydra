class ImageHostingError < StandardError #:nodoc:
end
class ImageHostingServiceAvailableError < ImageHostingError #:nodoc:
end
class ImageHostingLinksError < ImageHostingError #:nodoc:
end
class ImageHostingNotSupportError < ImageHostingError #:nodoc:
end

class ImageHosting
  include HTTParty
  cattr_reader :providers
  @provier = nil?
  @@providers = [ImageHosting::Imagevenue]

  class << self
    def file_to_post_param(body, param_name, file_path, file_name)
      body << "Content-Disposition: form-data; name=\"#{param_name}\"; "
      body << "filename=\"#{file_name}\"\r\n"
      body << "Content-Type: #{Rack::Mime.mime_type(File.extname(file_path))}\r\n"
      body << "Content-Transfer-Encoding: binary\r\n\r\n"
      body << File.open(file_path).binmode.read
    end
  end

end
