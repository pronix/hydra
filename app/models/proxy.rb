class Proxy < ActiveRecord::Base
  attr_accessor :proxies
  validates_presence_of :address
  validates_uniqueness_of :address
  belongs_to :user
  
  def proxies=(list_proxies)
    @list_proxies= list_proxies.scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d*/)
    unless @list_proxies.blank?
      self.address = @list_proxies.first
      @list_proxies.shift
      @list_proxies.each do |a|
        user.proxies.create :address => a
      end
    end

  end
  
  

end
