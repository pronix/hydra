class Proxy < ActiveRecord::Base
  GEOPATH = "#{RAILS_ROOT}/data/GeoLiteCity.dat"
  include AASM

  attr_accessor :proxies
  validates_presence_of :address
  validates_uniqueness_of :address, :scope => :user_id

  belongs_to :user

  named_scope :proxy_adresses, :select => "DISTINCT address"
  aasm_column :state
  aasm_initial_state :offline

  aasm_state :offline
  aasm_state :online

  aasm_event :fix do
    transitions :to => :online, :from => :offline
  end
  aasm_event :break do
    transitions :to => :offline, :from => :online
  end


  before_save :update_proxy
  def update_proxy
    geo = GeoIP.new(GEOPATH)
    find_country = geo.city(self.address.scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/).first) rescue nil
    self.country_code = find_country[2].downcase rescue nil
    self.country = find_country[3].upcase rescue nil
  end

  class << self
    # Добавление прокси
    def add_proxies(user,list_proxies)
      @list_proxies= list_proxies.scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d*/)
      geo = GeoIP.new(GEOPATH)

      create(@list_proxies.map{ |x|
               { :address => x, :user => user,
                 :country => (geo.city(x)[3].upcase rescue nil),
                 :country_code => (geo.city(x)[2].downcase rescue nil)
               }
             })
    end

    # Поверка прокси
    def checker
      @result = { true => [], false => []}

      proxy_adresses.map{|x| x.address.split(':')}.each do |proxy|
        begin
          @response_from_proxy = HTTParty.get('http://google.com',:timeout => 5,
                                              :http_proxyaddr => proxy.first, :http_proxyport => proxy.last)
          unless @response_from_proxy || @response_from_proxy.code > 200
            @response_from_proxy = HTTParty.get('http://ya.ru',:timeout => 5,
                                                :http_proxyaddr => proxy.first, :http_proxyport => proxy.last)
          end

          if @response_from_proxy && @response_from_proxy.code <= 200
            @result[true] << proxy.join(':')
          else
            @result[false] << proxy.join(':')
          end

        rescue Timeout::Error
          @result[false] << proxy.join(':')
        rescue
          @result[false] << proxy.join(':')
        end

      end

      update_all "state = 'online'",  [" address in (?) ", @result[true] ]
      update_all "state = 'offline'", [" address in (?) ", @result[false] ]

    end

  end


end
