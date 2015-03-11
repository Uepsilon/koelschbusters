# - encoding: utf-8 -
class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_and_authorize_resource

  def update
    if @user.update user_params
      flash[:notice] = 'Dein Profil wurde geändert.'
      redirect_to :user
    else
      render :edit
    end
  end

  def edit_login
    render :edit_login
  end

  def update_login
    if @user.update_with_password user_account_params
      sign_in @user, bypass: true

      unless params[:user][:password].nil?
        flash[:notice] = 'Dein Passwort wurde erfolgreich geändert.'
      end

      if @user.unconfirmed_email == params[:user][:email]
        flash[:notice] = 'Bitte bestätige deine neue E-Mail-Adresse. Wir haben dir dazu eine E-Mail geschickt.'
      end

      redirect_to :user
    else
      render :edit_login
    end
  end

  def remove_oauth
    if @user.remove_oauth(params[:provider])
      flash[:notice] = 'Die Verknüpfung mit #{params[:provider].capitalize} wurde entfernt.'
    else
      flash[:alert] = 'Die Verknüpfung mit #{params[:provider].capitalize} konnte nicht entfernt werden.'
    end

    redirect_to :user
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :mobile, :street, :houseno, :zipcode, :city)
  end

  def user_account_params
    params.require(:user).permit(:current_password, :email, :email_confirmation, :password, :password_confirmation)
  end

  def load_and_authorize_resource
    @user = User.find current_user.id
    authorize! :edit, @user
  end
end
