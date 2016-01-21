role :app, %w{root@192.168.178.100}
role :web, %w{root@192.168.178.100}
role :db,  %w{root@192.168.178.100}

namespace :deploy do
  desc "Update crontab with whenever"
  task :update_cron do
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
      end
    end
  end

  after :finishing, 'deploy:update_cron'
end

namespace :backup do

  desc "Upload backup config files."
  task :upload_config do
    on roles(:app) do
      execute "mkdir -p #{fetch(:backup_path)}/models"
      upload! StringIO.new(File.read("config/backup/config.rb")), "#{fetch(:backup_path)}/config.rb"
      upload! StringIO.new(File.read("config/backup/models/production_backup.rb")), "#{fetch(:backup_path)}/models/production_backup.rb"
    end
  end

  after :finishing, 'backup:upload_config'
end
