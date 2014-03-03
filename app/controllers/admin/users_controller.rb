class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource
  before_filter :check_not_self, :only => [:edit, :update, :destroy]
  add_breadcrumb I18n.t('links.users.index'), [:admin, :users]

  def index
    @users = @users.order(:last_name)
  end

  def new
    add_breadcrumb I18n.t('links.users.new'), new_admin_user_path
  end

  def create
    add_breadcrumb I18n.t('links.users.new'), new_admin_user_path

    if @user.save
      flash[:notice] = I18n.t('flash.users.created')
      redirect_to :admin_users
    else
      render :new
    end
  end

  def edit
    add_breadcrumb I18n.t('links.users.edit'), [:edit, :admin, @user]

  end

  def update
    add_breadcrumb I18n.t('links.users.edit'), [:edit, :admin, @user]

    @user.skip_reconfirmation!

    if @user.update_attributes params[:user]
      flash[:notice] = I18n.t('flash.users.updated')
      redirect_to :admin_users
    else
      render :edit
    end
  end

  def destroy
    @user.delete
    flash[:notice] = I18n.t('flash.users.deleted')

    redirect_to :admin_users
  end

  protected

  def check_not_self
    unless @user.id != current_user.id
      flash[:warning] = I18n.t('flash.users.cannot_edit_yourself')
      redirect_to :admin_users
    end
  end
end
