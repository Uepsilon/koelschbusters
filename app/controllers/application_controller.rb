class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do
    render :file => 'public/401.html', :status => :not_found, :layout => false
  end

end
