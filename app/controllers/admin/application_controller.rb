class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_admin

  protected

  def authorize_admin
    authorize! :access, :admin
  end
end
