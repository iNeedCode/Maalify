require 'rails-settings-ui'

#= Application-specific
#
# # You can specify a controller for RailsSettingsUi::ApplicationController to inherit from:
# RailsSettingsUi.parent_controller = 'Admin::ApplicationController' # default: '::ApplicationController'
#
# # Render RailsSettingsUi inside a custom layout (set to 'application' to use app layout, default is RailsSettingsUi's own layout)
# RailsSettingsUi::ApplicationController.layout 'admin'

# Rails.application.config.to_prepare do
#   # If you use a *custom layout*, make route helpers available to RailsSettingsUi:
#   # RailsSettingsUi.inline_main_app_routes!
# end


Rails.application.config.to_prepare do
  # Use admin layout:
  RailsSettingsUi::ApplicationController.module_eval do
    layout 'application'
  end
  RailsSettingsUi.settings_class = 'Setting'
  # If you are using a custom layout, you will want to make app routes available to rails-setting-ui:
  RailsSettingsUi.inline_main_app_routes!

end
