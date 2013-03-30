class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource
  before_filter :check_not_self, :only => [:edit, :update, :destroy]

  def index

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user]

    if @user.save
      flash[:notice] = "Mitglied wurde erstellt."
      redirect_to :admin_users
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @user.update_attributes! params[:user]
      flash[:notice] = "Mitglied wurde bearbeitet."
      redirect_to :admin_users
    else
      render :edit
    end
  end

  def destroy
    if @user.delete
      flash[:notice] = "Mitglied gelöscht."
    else
      flash[:alert] = "Mitglied konnte nicht gelöscht werden. Bitte mit dem Admin schimpfen."
    end

    redirect_to :admin_users
  end

  protected

  def check_not_self
    unless @user.id != current_user.id
      flash[:notice] = "Du sollst nicht an dir selber rumspielen!"
      redirect_to :admin_users
    end
  end
end
