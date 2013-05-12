class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource
  before_filter :check_not_self, :only => [:edit, :update, :destroy]
  add_breadcrumb :index, [:admin, :users]

  def index
  end

  def new
    add_breadcrumb :new, :new_admin_users
  end

  def create
    add_breadcrumb :new, :new_admin_users

    if @user.save
      flash[:notice] = I18n.t('flash.users.created')
      redirect_to :admin_users
    else
      render :new
    end
  end

  def edit
    add_breadcrumb :edit, [:admin, @user]

  end

  def update
    add_breadcrumb :edit, [:admin, @user]
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
