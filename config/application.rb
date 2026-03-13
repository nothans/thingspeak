require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Thingspeak
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_paths += %W(#{config.root}/lib)

    # fix invalid utf8 characters
    config.middleware.insert_before Rack::Runtime, Rack::UTF8Sanitizer

    # allow frames to work
    config.action_dispatch.default_headers = { 'X-Frame-Options' => 'ALLOWALL' }

    config.i18n.default_locale = :en

    config.filter_parameters += [:password]
  end
end
