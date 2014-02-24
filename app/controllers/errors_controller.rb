class ErrorsController < ApplicationController
  def access_denied
    respond_to do |format|
      format.html { render template: 'errors/access_denied', status: 401 }
      format.all { render nothing: true, status: 401 }
    end
  end

  def not_found
    respond_to do |format|
      format.html { render template: 'errors/not_found', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def unprocessable_entity
    render nothing: true, status: 422
  end

  def server_error
    respond_to do |format|
      format.html { render template: 'errors/internal_server_error', status: 500 }
      format.all { render nothing: true, status: 500}
    end
  end
end
