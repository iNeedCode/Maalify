# Initial server config for Banana Pi

# Server setup

### Banana Pi setup

**arbitrary setup guidelines for the banana pi:**

```
uname -a # uname Linux bananapi 3.4.108-bananian #2 SMP PREEMPT Thu Aug 13 06:08:25 UTC 2015 armv7l GNU/Linux

vi /etc/network/interfaces
iface eth0 inet static
address 192.168.178.100
netmask 255.255.255.0
gateway 192.168.178.1
/etc/init.d/networking restart

mkdir -p ~/.ssh/
# https://www.thomas-krenn.com/de/wiki/Perl_warning_Setting_locale_failed_unter_Debian
locale-gen en_US.UTF-8


df -h # disk space usage
apt-get update # system update
ssh-keygen -t rsa -b 2048 #genereate ssh key
cat ~/.ssh/id_rsa.pub | ssh root@192.168.178.100 'umask 077; cat >>.ssh/authorized_keys' # from host
```

### Required linux packages
```
apt-get update
apt-get -y install git-core curl build-essential zlib1g-dev libssl-dev libreadline-dev libxml2-dev libxslt1-dev nodejs sqlite3 libsqlite3-dev postgresql libffi-dev libpq-dev
aptitude install libffi-dev

# install nginx ppa, update and install nginx
add-apt-repository ppa:nginx/stable
aptitude update
aptitude -y install nginx
service nginx start
```

### Install Ruby with rbenv
```
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone https://github.com/sstephenson/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init -)"' >> ~/.zshrc


# choose version and install ruby
rbenv install -l
rbenv install 2.2.1
rbenv global 2.2.1
rbenv rehash
ruby -v

# optional, exclude documentation
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler
rbenv rehash
```

### Postgres
following setup is needed for the postgres setup:  

the following conf file need be updated `$ vi /etc/postgresql/9.4/main/pg_hba.conf` to the following configurations.


```
# Database administrative login by Unix domain socket
local   all             postgres                               ident

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                    md5
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
#local   replication     postgres                                peer
#host    replication     postgres        127.0.0.1/32            md5
#host    replication     postgres        ::1/128                 md5
```

Afterwards postgres needs to be restarted with `$ service nginx restart` and `$ /etc/init.d/postgresql reload`

#### Create the database user

Change to the postgres user with `$ su - postgres` and then open the console `$ psql` and paste the following commands in order to create the user.

```
create user maalify with password 'SET-YOUR-PASSWORD-HERE';
  create database maalify_production owner maalify;
  alter user maalify superuser createrole createdb replication;
```

#### dump production data to seeds file

In order to dump the production data to the seed file you need to add the following Gemfile `
gem 'seed_dump'` and afterwards execute the according rake task with `rake db:seed:dump`. That will ***override*** your seeds.rb file.

```
$ ~/Desktop
$ scp root@192.168.178.100:/opt/www/maalify/current/db/seeds.rb ./
```



# Deployment

## Nginx

create Nginx site under `$ vi /etc/nginx/sites-available/maalify` and delete the default site `$ rm /etc/nginx/sites-enabled/default`

```
upstream app {
    # Path to Unicorn SOCK file, as defined previously

    server unix:/opt/www/maalify/shared/tmp/sockets/unicorn.sock fail_timeout=0;
}

server {
    listen 80;
    server_name localhost;

    root /opt/www/maalify/current/public;

    try_files $uri/index.html $uri @app;

    location @app {
        proxy_pass http://app;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
    }

    error_page 500 502 503 504 /500.html;
    client_max_body_size 4G;
    keepalive_timeout 10;
}

```
afterwards symlink the maalify site to the available ones with `$ ln -s /etc/nginx/sites-available/maalify /etc/nginx/sites-enabled/maalify` in the next you have to restart the Nginx server with `$ service nginx restart`


## Unicorn

create the following file `$ vi /etc/init.d/unicorn_maalify` for the unicorn restart

```
#!/bin/bash

### BEGIN INIT INFO

# Provides:          unicorn
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the unicorn app server
# Description:       starts unicorn using start-stop-daemon

### END INIT INFO


set -e

USAGE="Usage: $0 <start|stop|restart|upgrade|rotate|force-stop>"

# app settings

USER="root"
APP_NAME="maalify"
APP_ROOT="/opt/www/$APP_NAME/current"
ENV="production"

# environment settings

PATH="/root/.rbenv/shims:/root/.rbenv/bin:$PATH"
CMD="cd $APP_ROOT && bundle exec unicorn -c config/unicorn.rb -E $ENV -D"
PID="$APP_ROOT/shared/tmp/pids/unicorn.pid"
OLD_PID="$PID.oldbin"

# make sure the app exists

cd $APP_ROOT || exit 1

sig () {
  test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
  test -s $OLD_PID && kill -$1 `cat $OLD_PID`
}

case $1 in
  start)
    sig 0 && echo >&2 "Already running" && exit 0
    echo "Starting $APP_NAME"
    su - $USER -c "$CMD"
    ;;
  stop)
    echo "Stopping $APP_NAME"
    sig QUIT && exit 0
    echo >&2 "Not running"
    ;;
  force-stop)
    echo "Force stopping $APP_NAME"
    sig TERM && exit 0
    echo >&2 "Not running"
    ;;
  restart|reload|upgrade)
    sig USR2 && echo "reloaded $APP_NAME" && exit 0
    echo >&2 "Couldn't reload, starting '$CMD' instead"
    $CMD
    ;;
  rotate)
    sig USR1 && echo rotated logs OK && exit 0
    echo >&2 "Couldn't rotate logs" && exit 1
    ;;
  *)
    echo >&2 $USAGE
    exit 1
    ;;
esac
```

**create afterwards the correct privilege for the created file with the following commands**  

- `chmod 755 /etc/init.d/unicorn_maalify`  
- `service unicorn_maalify start`


## Start Unicorn on OS start up

There are 3 options to start unicorn on start up of the OS.

**1)** Edit the crontab list

    sudo crontab -e
    # put the following line into file
    @reboot sh /root/script.sh

**2)** make the unicon_maalify start by default

    sudo update-rc.d unicorn_maalify defaults 
    
**3)** Edit `/etc/rc.local` file
    
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
    cd /opt/www/maalify/current && RAILS_ENV=production bundle exec unicorn -E production -c config/unicorn.rb -D 

#### The Content of the script.sh file is:
 
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
    cd /opt/www/maalify/current && RAILS_ENV=production bundle exec unicorn -E production -c config/unicorn.rb -D

## troubleshooting

##### master failed to start, check stderr log for details
look into log file for the exact error in `$ less /opt/www/maalify/shared/log/unicorn.stderr.log` or empty out the pid file `$ less /opt/www/maalify/shared/tmp/pids/unicorn.pid`

kill the unicorn master worker with `$ kill PID`. Search the right process with `$ ps -ef | grep unicorn`.


## Resources

- [Server Deployment](http://www.rubytreesoftware.com/resources/ruby-on-rails-41-ubuntu-1404-server-deployment) and the  according [video](https://www.youtube.com/watch?v=2NIm4iRKb6E) 
- [Server Configuration](http://www.rubytreesoftware.com/resources/ruby-on-rails-41-ubuntu-1404-server-configuration)
- [Rails deployment](http://ymcagodme.logdown.com/posts/280168-deploy-rails-app)
- [Digital Ocean with Unicorn and Nginx](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-unicorn-and-nginx-on-ubuntu-14-04)
- [Postgres Backup](http://vladigleba.com/blog/2014/06/30/backup-a-rails-database-with-the-backup-and-whenever-gems/)


