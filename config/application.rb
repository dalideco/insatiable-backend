require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InsatiableBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.exceptions_app = ->(env) { ActionDispatch::PublicExceptionsPlus.new(Rails.public_path).call(env) }

    # create a logger with a file as a logging target
    config.logger = Logger.new('log/important.log')
    # set the minimum log level
    config.log_level = :warn

    config.api_only = true
  end
end
