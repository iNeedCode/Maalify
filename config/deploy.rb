# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'maalify'
set :repo_url, 'git@github.com:iNeedCode/Maalify.git'
set :deploy_to, '/opt/www/maalify'
set :user, 'root'
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets}
set :keep_releases, 4

set :rbenv_ruby, '2.2.1'
set :rbenv_type, :system
set :rbenv_path, "~/.rbenv"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)
set :rbenv_roles, :all
set :linked_files, %w{config/database.yml .rbenv-vars application.yml} # create these files manually ones on the server
set :backup_path, "/#{fetch(:user)}/Backup"


# Capristrano3 unicorn
set :unicorn_pid, "/opt/www/maalify/shared/tmp/pids/unicorn.pid"
set :unicorn_config_path, "/opt/www/maalify/current/config/unicorn.rb"

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  task :restart do
    invoke 'unicorn:legacy_restart'
  end
end
