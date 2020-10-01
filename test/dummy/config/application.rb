require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)
require "seiten"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en, :de]
  end
end

