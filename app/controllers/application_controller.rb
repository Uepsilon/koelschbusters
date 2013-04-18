class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  rescue_from CanCan::AccessDenied do
    render :file => 'public/404', :format => :html, :status => :not_found, :layout => false
  end

  protected

  def record_not_found
    render :file => "public/404", :format => :html, :status => :not_found, :layout => false
  end

end
