class ApplicationController < ActionController::API
  include ActionController::ImplicitRender

  self.responder = ApplicationResponder
  respond_to :json
end
