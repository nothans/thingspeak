Thingspeak::Application.configure do
  # required by devise
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.log_level = :warn

  config.public_file_server.enabled = false

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.assets.compile = false
  config.assets.js_compressor = :uglifier
end
