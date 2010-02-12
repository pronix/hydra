require 'xmlrpc/client'

module Aria2cRcp
  def self.add_list_uri(resources, options)
    client.call()
  end
  def self.add_uri(resources, options)
    client.call("aria2.addUri", resources, options)
  end
  def self.status(gid)
    client.call("aria2.tellStatus",gid)
  end
  def self.remove(gid)
    client.call("aria2.remove",gid)
  end

  def self.tell_active
    client.call("aria2.tellActive")
  end

  def self.tell
    {
      :active => client.call("aria2.tellActive"),
      :stopped => client.call("aria2.tellStopped",-1,10000),
      :waiting =>  client.call("aria2.tellWaiting",-1,10000)
    }



  end

  private
  def self.client
    unless @client
      options = YAML.load(File.read(File.join(RAILS_ROOT,'config','aria', 'aria.yml')))[RAILS_ENV]
      @_client=XMLRPC::Client.new3({:host => options["server"],
                             :port => options["port"],
                             :path => "/rpc",
                             :user => options["user"],
                             :password => options["password"]})
    end
    @_client
  rescue
    false
  end
end