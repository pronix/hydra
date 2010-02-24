class ImageHosting
  include HTTParty
  cattr_reader :providers
  @provier = nil?
  @@providers = [ImageHosting::Imagevenue]

end
