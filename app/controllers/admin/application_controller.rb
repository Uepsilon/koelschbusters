class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_admin
  layout 'admin'

  add_breadcrumb I18n.t('links.dashboard'), :admin_root_path

  protected

  def authorize_admin
    authorize! :access, :admin
  end
end
