
# set path to application
app_dir = "/opt/www/maalify"
shared_dir = "#{app_dir}/shared"
working_directory "#{app_dir}/current"

# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Set up socket location
listen "#{shared_dir}/tmp/sockets/unicorn.sock", :backlog => 64

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{shared_dir}/tmp/pids/unicorn.pid"
