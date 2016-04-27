# TODO The middleware lines should go away, once the following PR
#   is merged to Rails
# https://github.com/rails/rails/pull/19710
Rails.application.config.middleware.delete 'ActionDispatch::RemoteIp'
Rails.application.config.middleware.insert_before Rails::Rack::Logger,
  ActionDispatch::RemoteIp,
  Rails.application.config.action_dispatch.ip_spoofing_check,
  Rails.application.config.action_dispatch.trusted_proxies
