class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource
  before_filter :check_not_self, only: %i(edit update destroy)
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

    if @user.update user_params
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

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :phone, :mobile,
                                 :street, :houseno, :zipcode, :city, :member_active, :role)
  end

  def check_not_self
    return if  @user.id != current_user.id

    flash[:warning] = I18n.t('flash.users.cannot_edit_yourself')
    redirect_to :admin_users
  end
end
