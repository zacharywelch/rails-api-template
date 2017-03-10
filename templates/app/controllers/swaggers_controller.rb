class SwaggersController < ApplicationController

  skip_before_action :authenticate

  # GET /swagger.json
  def show
    render file: 'public/swagger.json'
  end
end
