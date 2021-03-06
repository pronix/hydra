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

set :port,2222
role :app, "c-n150-u0496-25.webazilla.com"
role :web, "c-n150-u0496-25.webazilla.com"
role :db,  "c-n150-u0496-25.webazilla.com" , :primary => true


set(:shared_database_path) {"#{shared_path}/databases"}
set(:ruby_path,"/opt/ruby-enterprise-1.8.7-2010.02/bin")

before "deploy:setup","deploy:mkdir_data"
namespace :deploy do
  desc "Directories for data"
  task :mkdir_data, :roles => :app do
    run "mkdir -p #{shared_path}/data/{arhive_attahments,covers,user_files,screen}"
  end

  desc "Restarting passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with passenger"
    task t, :roles => :app do ; end
  end

  task :chown, :roles => :app do
    run "chown -R hydra:hydra #{release_path}"
  end

  desc "create symlinks on shared resources"
  task :symlinks do
    %w{task_files covers screen arhive_attahments }.each do |share|
      run "mkdir -p #{shared_path}/data/#{share}" unless File.exist?("#{shared_path}/data/#{share}")
      run "ln -nfs #{shared_path}/data/#{share} #{release_path}/data/#{share} "
    end
#    run "ln -nfs  /var/www/hydra/shared/production.sqlite3 #{release_path}/db/production.sqlite3"
#    run "touch #{shared_path}/database.yml"
    run "ln -nfs #{shared_path}/database.yml #{current_path}/config/database.yml "
    run "ln -nfs #{shared_path}/application.yml #{current_path}/config/application.yml "

  end
  desc "start aria server"
  task :start_aria do
    run "cd #{current_path} && RAILS_ENV=production #{ruby_path}/rake hydra:aria2c:start"
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
    run "/opt/ruby-enterprise-1.8.7-2010.02/bin/bluepill stop"
    run "/opt/ruby-enterprise-1.8.7-2010.02/bin/bluepill quit"
    rescue =>e
      puts e
    end
  end
  desc "Load bluepill configuration and start it"
  task :start, :roles => [:app] do
    run "RAILS_ENV=production /opt/ruby-enterprise-1.8.7-2010.02/bin/bluepill load #{current_path}/config/production.pill"
  end
  desc "Prints bluepills monitored processes statuses"
  task :status, :roles => [:app] do
    run "RAILS_ENV=production /opt/ruby-enterprise-1.8.7-2010.02/bin/bluepill status"
  end
end
# after  "deploy"update_code

after "deploy:update",  "deploy:symlinks", "deploy:chown", "deploy:start_aria", "deploy:restart_daemons", "bluepill:quit", "bluepill:start"
