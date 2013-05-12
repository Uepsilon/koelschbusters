# - encoding: utf-8 -
class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_and_authorize_resource

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes params[:user]
      flash[:notice] = "Dein Profil wurde geändert."
      redirect_to :user
    else
      flash[:alert] = @user.errors

      render :edit
    end
  end

  def edit_login
    render :edit_login
  end

  def update_login
    if @user.update_with_password(params[:user])
      sign_in @user, :bypass => true
      redirect_to :user
    else
      flash[:alert] = @user.errors
      render :edit_login
    end
  end

  def remove_oauth
    if @user.remove_oauth(params[:provider])
      flash[:notice] = "Die Verknüpfung mit #{params[:provider].capitalize} wurde entfernt."
    else
      flash[:alert] = "Die Verknüpfung mit #{params[:provider].capitalize} konnte nicht entfernt werden."
    end

    redirect_to :user
  end

  protected

  def load_and_authorize_resource
    @user = User.find current_user.id
    authorize! :edit, @user
  end
end
