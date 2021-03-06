#!/usr/bin/ruby

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'environment'))
require 'optparse'
require "daemon-spawn"

SLEEP = 15
class DaemonMonitorDownloading < DaemonSpawn::Base
  def start(args)
    loop do
      begin
        # DownloadingFile.process
        `/var/www/hydra/current/script/runner -e production 'DownloadingFile.process'`
      rescue
        STDERR.puts  " #{$!.inspect} "
      end
      sleep(SLEEP)
    end
  end

  def stop
    puts "Monitor Downloading stopping"
  end
end
 # DownloadingFile.process
DaemonMonitorDownloading.spawn!(:working_dir => File.join(File.dirname(__FILE__)),
                   :log_file => "#{RAILS_ROOT}/log/monitor_downloading.log",
                   :pid_file => "#{RAILS_ROOT}/tmp/pids/monitor_downloading.pid",
                   :sync_log => true,
                   :singleton => true)
