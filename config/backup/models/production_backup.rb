db_config = YAML.load_file('/opt/www/maalify/current/config/database.yml')['production']
app_config = YAML.load_file('/opt/www/maalify/current/application.yml')

Model.new(:production_backup, 'backing up production database') do

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

  store_with Dropbox do |db|
    db.api_key     = app_config['dropbox_key']
    db.api_secret  = app_config['dropbox_secret']
    # Sets the path where the cached authorized session will be stored.
    # Relative paths will be relative to ~/Backup, unless the --root-path
    # is set on the command line or within your configuration file.
    db.cache_path  = ".cache"
    # :app_folder (default) or :dropbox
    db.access_type = :app_folder
    db.path        = "/root/backups"
    # Use a number or a Time object to specify how many backups to keep.
    db.keep        = 5
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
