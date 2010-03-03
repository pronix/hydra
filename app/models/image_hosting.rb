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
    def form_data

    end
  end

end
