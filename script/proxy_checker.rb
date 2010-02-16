#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'environment'))
require 'optparse'
require "daemon-spawn"

SLEEP = 1.hours
class DaemonProxyChecker < DaemonSpawn::Base
  def start(args)
    loop do
      begin
        Proxy.checker
      rescue
        STDERR.puts  " #{$!.inspect} "
      end
      sleep(SLEEP)
    end
  end

  def stop
    puts "Proxy Checker stopping"
  end
end

DaemonProxyChecker.spawn!(:working_dir => File.join(File.dirname(__FILE__)),
                   :log_file => "#{RAILS_ROOT}/log/proxy_checker.log",
                   :pid_file => "#{RAILS_ROOT}/tmp/pids/proxy_checker.pid",
                   :sync_log => true,
                   :singleton => true)
