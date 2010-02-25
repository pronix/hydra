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

role :app, "#{application}"
role :web, "#{application}"
role :db,  "#{application}" , :primary => true


set(:shared_database_path) {"#{shared_path}/databases"}



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
      run "ln -nfs #{shared_path}/#{share} #{release_path}/data/#{share} "
    end
  end

end
after  "deploy", "deploy:chown", "deploy:symlinks"


# namespace :sqlite3 do
#   desc "Generate a database configuration file"
#   task :build_configuration, :roles => :db do
#     db_options = {
#       "adapter" =>  "postgresql",
#       "encoding" => "unicode",
#       "database" => "hydra",
#       "pool" => 5,
#       "username" => "hydra",
#       "password" => "hydra",
#     }
#     config_options = {"production" => db_options}.to_yaml
#     put config_options, "#{shared_path}/database_config.yml"
#   end

#   desc "Links the configuration file"
#   task :link_configuration_file, :roles => :db do
#     run "ln -nsf #{shared_path}/database_config.yml #{current_path}/config/database.yml"
#   end

#   desc "Make a shared database folder"
#   task :make_shared_folder, :roles => :db do
#     run "mkdir -p #{shared_database_path}"
#   end
# end

# after "deploy" , "sqlite3:build_configuration", "sqlite3:link_configuration_file", "deploy:symlinks"
# after  "deploy",   "deploy:link_current_to_appache_folder", "deploy:symlinks"













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
