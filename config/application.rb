require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bookseattle
  class Application < Rails::Application

    config.api_only = true
    # Force new test files to be generated in the minitest-spec style
    config.generators do |g|
      g.test_framework :minitest, spec: true
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:8080'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
