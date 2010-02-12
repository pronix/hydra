# encoding: utf-8
namespace :hydra do
  namespace :aria2c do
    desc "Started with aria2 XML-RPC API"
    task :start => :environment do
      options = YAML.load(File.read(File.join(RAILS_ROOT,'config','aria', 'aria.yml')))[RAILS_ENV]
      command =[options["command"], "--daemon", options.except("command").map {|k,v| "#{k}=#{v}"}].flatten.join(' ')
      puts command
      system(command)
    end
  end
end
