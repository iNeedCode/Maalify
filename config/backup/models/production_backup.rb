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
    mail.on_success           = false
    mail.on_warning           = false
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
