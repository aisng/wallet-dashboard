require_relative 'boot'

# require 'rails/all'
# require 'active_record/railtie'
# require 'active_storage/engine'
# require 'action_view/railtie'
# require 'action_mailer/railtie'
# require 'action_mailbox/engine'
# require 'rails/test_unit/railtie'
require 'action_controller/railtie'
require 'active_job/railtie'
require 'action_cable/engine'
require 'action_text/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WalletDashboard
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
