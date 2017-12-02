class ApplicationMailer < ActionMailer::Base
  config = YAML.load_file("#{Rails.root.to_s}/application.yml")

  default from: 'Maalify <maalifyprogramm@gmail.com>'
  default delivery_method_options: {api_key: config['mailjet_api_key'], secret_key: config['mailjet_sec']}
end
