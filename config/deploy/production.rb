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
