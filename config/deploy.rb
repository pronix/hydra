default_run_options[:pty] = true
set :application, "hydra"

set :scm, :git
set :repository,  "git@github.com:pronix/hydra.git"
set :ssh_options, {:forward_agent => true}
set :branch, "master"

set :user, "root"

set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false

role :app, "adenin.ru"
role :web, "adenin.ru"
role :db,  "adenin.ru" , :primary => true


set(:shared_database_path) {"#{shared_path}/databases"}
set(:ruby_path,"/opt/ruby-enterprise-1.8.7-2010.01/bin")

namespace :deploy do
  desc "Restarting passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with passenger"
    task t, :roles => :app do ; end
  end

  task :chown, :roles => :app do
    run "chown -R apache:apache #{release_path}"
  end

  desc "create symlinks on shared resources"
  task :symlinks do
    %w{task_files covers screen arhive_attahments }.each do |share|
      run "mkdir -p #{shared_path}/data/#{share}" unless File.exist?("#{shared_path}/data/#{share}")
      run "ln -nfs #{shared_path}/data/#{share} #{release_path}/data/#{share} "
    end
    run "ln -nfs  /var/www/hydra/shared/production.sqlite3 #{release_path}/db/production.sqlite3"
    run "touch #{shared_path}/database.yml"
    run "ln -nfs #{shared_path}/database.yml #{current_path}/config/database.yml "

  end
  desc "start aria server"
  task :start_aria do
    run "cd #{current_path} && RAILS_ENV=production #{ruby_path}/rake hydra:aria2c:start "
  end


  desc "restart daemons"
  task :restart_daemons do
    run "cd #{current_path} && \
         RAILS_ENV=production #{ruby_path}/ruby script/proxy_checker.rb stop && \
         RAILS_ENV=production #{ruby_path}/ruby script/monitor_downloading.rb stop \
         cd #{current_path} && \
         RAILS_ENV=production #{ruby_path}/ruby script/proxy_checker.rb start && \
         RAILS_ENV=production #{ruby_path}/ruby script/monitor_downloading.rb start "
  end
  desc "start daemons"
  task :start_daemons do
    run "cd #{current_path} && RAILS_ENV=production #{ruby_path}/rake hydra:daemons:start "
  end

  desc "stop daemons"
  task :stop_daemons do
    run "cd #{current_path} && RAILS_ENV=production #{ruby_path}/rake hydra:daemons:stop "
  end

end

namespace :bluepill do
  desc "Stop processes that bluepill is monitoring and quit bluepill"
  task :quit, :roles => [:app] do
    begin
    run "bluepill stop"
    run "bluepill quit"
    rescue =>e
      puts e
    end
  end
  desc "Load bluepill configuration and start it"
  task :start, :roles => [:app] do
    run "/opt/ruby-enterprise-1.8.7-2010.01/bin/bluepill load #{current_path}/config/production.pill"
  end
  desc "Prints bluepills monitored processes statuses"
  task :status, :roles => [:app] do
    run "/opt/ruby-enterprise-1.8.7-2010.01/bin/bluepill status"
  end
end
# after  "deploy"update_code

after "deploy:update",  "deploy:symlinks", "deploy:chown", "deploy:start_aria", "deploy:restart_daemons", "bluepill:quit", "bluepill:start"















# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
