# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, "production"
set :whenever_command, "bundle exec whenever"
set :output, {:error => "/opt/www/maalify/current/log/cron_error_log.log", :standard => "/opt/www/maalify/current/log/cron_log.log"}
env :GEM_PATH, ENV['/root/.rbenv/shims/gem']


# monthly email to all members in system
every 1.day, at: '6:00am' do
  command "gem install rake"
  rake 'cron:deliver_emails'
end

every 1.day, at: '11:59 pm' do
  rake 'cron:save_jamaat_to_disk'
  command "backup perform -t production_backup"
end

# check
every 1.day, at: '5:00 am' do
  command "gem install rake"
  rake 'cron:deliver_emails_to_report_subscribers'
end
