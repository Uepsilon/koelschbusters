class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_admin

  layout 'admin'
  add_breadcrumb :index, :admin_root

  protected

  def authorize_admin
    authorize! :access, :admin
  end
end
