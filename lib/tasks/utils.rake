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

  namespace :daemons do
    desc "Start all daemons (proxy_checker, downloading monitor, delayed_job)"
    task :start => :environment do
      if system(File.join(RAILS_ROOT, 'script', 'proxy_checker.rb start'))
        puts "Start proxy_checker: Ok"
      else
        puts "Start proxy_checker: Fail"
      end

      if system(File.join(RAILS_ROOT, 'script', 'monitor_downloading.rb start '))
        puts "Start monitor_downloading: Ok"
      else
        puts "Start monitor_downloading: Fail"
      end

      if system(File.join(RAILS_ROOT, 'script', 'delayed_job start'))
        puts "Start delayed_job: Ok"
      else
        puts "Start delayed_job: Fail"
      end
    end
    desc "Stop all daemons (proxy_checker, downloading monitor, delayed_job)"
    task :stop => :environment do
      system(File.join(RAILS_ROOT, 'script', 'proxy_checker.rb stop'))
      puts "proxy checker stopped"
      system(File.join(RAILS_ROOT, 'script', 'monitor_downloading.rb stop'))
      puts "monitor_downloading stopped"
      system(File.join(RAILS_ROOT, 'script', 'delayed_job stop'))
      puts "Daemons stopped"
    end
  end
end
