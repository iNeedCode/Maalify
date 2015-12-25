# root = "/opt/www/maalify/current"
# working_directory root
# pid "#{root}/tmp/pids/unicorn.pid"
# stderr_path "#{root}/log/unicorn.log"
# stdout_path "#{root}/log/unicorn.log"
#
# listen "/tmp/unicorn.maalify.sock"
# worker_processes 1
# timeout 30

# set path to application

app_dir = "/opt/www/maalify/current"
working_directory app_dir

# Set unicorn options
worker_processes 1
preload_app true
timeout 30

# Set up socket location

listen "#{app_dir}/tmp/sockets/unicorn.maalify.sock", :backlog => 64

# Logging
stderr_path "#{app_dir}/log/unicorn.log"
stdout_path "#{app_dir}/log/unicorn.log"

# Set master PID location

pid "#{app_dir}/tmp/pids/unicorn.pid"
