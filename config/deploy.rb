# Automatically precompile assets
load "deploy/assets"

# Execute "bundle install" after deploy, but only when really needed
require "bundler/capistrano"

# RVM integration
require "rvm/capistrano"

set :application, "render"
set :rails_env, :production
set :domain, "simplepage.biz"

set :use_sudo, false
set :rvm_ruby_string, 'ruby-2.0.0-p195@render'
set :rvm_type, :user

set :hostingserver, "picfield.com"
set :user,          "vick"
set :port,          22

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
set :repository,  "git@github.com:vickodin/render.git"
set :branch,      "master"

# Deploy via github
set :deploy_via, :remote_cache
set :deploy_to, "/home/vhosts/simplepage.biz/#{application}"

set :shared_files,  %w(config/database.yml config/config.yml)

ssh_options[:forward_agent] = true

role :web, hostingserver                          # Your HTTP server, Apache/etc
role :app, hostingserver                          # This may be the same as your `Web` server
role :db,  hostingserver, :primary => true    # This is where Rails migrations will run
#role :db,  "your slave db-server here"     # No slave at this moment

# Install RVM and Ruby before deploy
before "deploy:setup", "rvm:install_rvm"
before "deploy:setup", "rvm:install_ruby"

after "deploy:setup", "deploy:set_rvm_version"

after "deploy:finalize_update", "deploy:update_shared_symlinks"

# Unicorn config
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_binary, "bash -c 'bundle exec unicorn_rails -c #{unicorn_config} -E #{rails_env} -D'"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    # Start unicorn server using sudo (rails)
    run "cd #{current_path} && #{unicorn_binary}"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "if [ -f #{unicorn_pid} ]; then kill `cat #{unicorn_pid}`; fi"
  end

  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "if [ -f #{unicorn_pid} ]; then kill -s QUIT `cat #{unicorn_pid}`; fi"
  end

  task :reload, :roles => :app, :except => { :no_release => true } do
    run "if [ -f #{unicorn_pid} ]; then kill -s USR2 `cat #{unicorn_pid}`; fi"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end

  task :set_rvm_version, :roles => :app, :except => { :no_release => true } do
    run "rvm use #{rvm_ruby_string}"
  end

  task :update_shared_symlinks do
    shared_files.each do |path|
      run "rm -rf #{File.join(release_path, path)}"
      run "ln -s #{File.join(deploy_to, "shared", path)} #{File.join(release_path, path)}"
    end

    #run "ln -s #{File.join(deploy_to, "shared", uploads_files[1])} #{File.join(release_path, uploads_files[0])}"

  end

  # Precompile assets only when needed
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      # If this is our first deploy - don't check for the previous version
      if remote_file_exists?(current_path)
        from = source.next_revision(current_revision)
        if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
          run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
        else
          logger.info "Skipping asset pre-compilation because there were no asset changes"
        end
      else
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      end
    end
  end
end

# Helper function
def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end
