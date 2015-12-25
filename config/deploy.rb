# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'maalify'
set :repo_url, 'git@github.com:iNeedCode/Maalify.git'
set :deploy_to, '/opt/www/maalify'
set :user, 'root'
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets}


set :rbenv_ruby, '2.2.1'
set :rbenv_type, :user
set :rbenv_path, "~/.rbenv"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)
set :rbenv_roles, :all
set :linked_files, %w{config/database.yml .rbenv-vars} # create these files manually ones on the server



# Capristrano3 unicorn

set :unicorn_pid, "/opt/www/maalify/current/shared/tmp/pids/unicorn.pid"
set :unicorn_config_path, "/opt/www/maalify/current/config/unicorn.rb"

# Clean up all older releases

before :deploy, "unicorn:stop"
after "deploy:publishing", "unicorn:start"
after "deploy:restart", "deploy:cleanup"


namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute :rake, 'cache:clear'
    end
  end

end
#
#
# namespace :deploy do
#
#   %w[start stop restart].each do |command|
#     desc 'Manage Unicorn'
#     task command do
#       on roles(:app), in: :sequence, wait: 1 do
#         execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
#       end
#     end
#   end
#
#   after :publishing, :restart
#
#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end
#
# end


# SSHKit.config.command_map[:rake] = "bundle exec rake"
# set :rvm_ruby_version, '2.2.0@maalify'
# set :rvm_type, :system

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
