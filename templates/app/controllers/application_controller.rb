class ApplicationController < ActionController::API
  include ActionController::ImplicitRender
  include Logging

  self.responder = ApplicationResponder
  respond_to :json
end
