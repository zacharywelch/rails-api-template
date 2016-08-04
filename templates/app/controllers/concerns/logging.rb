module Logging
  extend ActiveSupport::Concern

  private

  def append_info_to_payload(payload)
    super
    payload[:remote_ip] = request.remote_ip
    payload[:uuid] = request.uuid
    payload[:user_id] = request.headers['X-User-Id']
    payload[:impersonated_user_id] = request.headers['X-Impersonated-User-Id']
    if request.authorization
      payload[:partner_id] = request.authorization.split(':').first
    end
  end
end
