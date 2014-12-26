class ErrorsController < ApplicationController
  def access_denied
    render_401
  end

  def not_found
    render_404
  end

  def unprocessable_entity
    render_422
  end

  def server_error
    render_500
  end
end
