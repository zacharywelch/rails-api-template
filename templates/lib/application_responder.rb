class ApplicationResponder < ActionController::Responder
  include Responders::HttpCacheResponder
  include Responders::JsonResponder
  include Responders::PaginationResponder
end
