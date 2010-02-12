# encoding: utf-8
namespace :hydra do
  namespace :aria2c do
    desc "Started with aria2 XML-RPC API"
    task :start => :environment do
      options = YAML.load(File.read(File.join(RAILS_ROOT,'config','aria', 'aria.yml')))[RAILS_ENV]
      command =[options["command"], "--daemon","-q",
                "--xml-rpc-listen-port=#{options["port"]}", "--xml-rpc-user=#{options["user"]}",
                "--xml-rpc-passwd=#{options["password"]}"
                ].join(" ")

      puts command
      ps_ax = IO.popen("ps ax | grep  '#{command}' | grep -v grep ")
      ps_ax = ps_ax.readlines
      if ps_ax.blank?
        system(command)
      else
        puts "[aria] - не запускаем"
        puts ps_ax
      end
    end
  end
end
