class ApplicationController < ActionController::Base
  protect_from_forgery

  unless Rails.env.development?
    rescue_from Exception, with: :render_500
    rescue_from CanCan::AccessDenied, with: :render_401
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ::AbstractController::ActionNotFound, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
  end

  protected

  def render_401(exception = nil)
    @not_found_path = exception.message unless exception.nil?
    render_errors(401, 'access_denied')
  end

  def render_404(exception = nil)
    @not_found_path = exception.message unless exception.nil?
    render_errors(404, 'not_found')
  end

  def render_422(exception = nil)
    @not_found_path = exception.message unless exception.nil?
    render nothing: true, status: 422
  end

  def render_500(exception = nil)
    logger.debug exception.backtrace.join("\n") unless exception.nil?
    render_errors(500, 'internal_server_error')
  end

  def render_errors(status, error)
    respond_to do |format|
      format.html { render "errors/#{error}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end
end
