class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_admin
  layout 'admin'

  add_breadcrumb I18n.t('breadcrumbs.dashboard'), :admin_root_path

  private

  def authorize_admin
    authorize! :access, :admin
  end
end
