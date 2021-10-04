# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "Cardinal_Talent"
set :repo_url, "git@github.com:cardinalhire/ch-job-marketplace.git"
# set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa) }
set :deploy_to, "/home/siva/ch-job-marketplace"
set :pty, true

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", ".bundle", "public/system", "public/uploads", "public/packs", "public/images", "node_modules"
append :linked_files, ".env", "config/master.key"

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Makes capistrano bundler verbose
set :bundle_flags, '--deployment'
# set :linked_files, %w{config/database.yml}
# set :rvm_map_bins
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.6.5'
# set :nvm_type, :user
# set :nvm_node, 'v12.22.1'
# set :nvm_map_bins, %w{node npm yarn}
# set :yarn_flags, %w{--silent --no-progress}

set :assets_roles, []
set :env_file, '.env'

# set :stage,           :production
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{release_path}/log/puma_access.log"
set :puma_error_log, "#{release_path}/log/puma_error.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false
set :puma_restart_command, 'bundle exec puma'

set :nginx_sites_available_path, "/etc/nginx/sites-available"
set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before 'deploy:starting', 'puma:make_dirs'
end



namespace :deploy do

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      invoke 'deploy'
    end
  end

  task :webpack_compile do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:stage) do
          # execute :yarn, "install", "--ignore-engines"
          execute :bundle , 'exec', "rake assets:precompile"
        end
      end
    end
  end


  desc "Restart Puma"
  task :restart_puma do
    on roles(:app), in: :sequence, wait: 5 do
      execute 'sudo', 'systemctl', 'restart', 'puma.service'
    end
  end

  desc "Restart Nginx"
  task :restart_nginx do
    on roles(:app), in: :sequence, wait: 5 do
      execute 'sudo', 'systemctl', 'restart', 'nginx'
    end
  end

  desc "Restart sidekiq"
  task :restart_sidekiq do
    on roles(:app), in: :sequence, wait: 5 do
      execute :sudo, :systemctl, :restart, :sidekiq
    end
  end

  after  :finishing,    :webpack_compile
  after  :finishing,    :restart_puma
  after  :finishing,    :restart_sidekiq
  after  :finishing,    :restart_nginx
  after "deploy:restart", "deploy:cleanup"
end
