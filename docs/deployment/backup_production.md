#Production database backup 
log into the server and install the gem backup with `gem install backup`.


```
# encoding: utf-8

##
# Backup Generated: production_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t production_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#

db_config = YAML.load_file('/opt/www/maalify/current/config/database.yml')['production']
app_config = YAML.load_file('/opt/www/maalify/current/application.yml')


Model.new(:production_backup, 'Description for production_backup') do

  ##
  # PostgreSQL [Database]
  #
  database PostgreSQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = db_config['database'] 
    db.username           = db_config['username'] 
    db.password           = db_config['password'] 
    db.host               = "localhost"
    db.port               = 5432
    db.additional_options = ["-xc", "-E=utf8"]
  end

  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path       = "~/backups/"
    local.keep       = 5
  end

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the documentation for other delivery options.
  #
  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = app_config['email_username']
    mail.to                   = app_config['email_to']
    mail.address              = app_config['email_address']
    mail.port                 = app_config['email_port']
    mail.user_name            = app_config['email_username']
    mail.password             = app_config['email_password']
    mail.authentication       = "plain"
    mail.encryption           = :starttls
  end

end

```


backup check
backup perform --trigger production_backup
