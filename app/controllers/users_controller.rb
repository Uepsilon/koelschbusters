# - encoding: utf-8 -

class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user


  def show
  end

  def edit
  end

  def update
    if @user.update_attributes params[:user]
      flash[:notice] = "Dein Profil wurde geändert."
      redirect_to :user
    else
      render :edit
    end
  end

  def edit_login
    render :login
  end

  def update_login
    @user = User.find(current_user.id)
    if @user.update_with_password(params[:user])
      sign_in @user, :bypass => true
      redirect_to :user
    else
      render :login
    end
  end

  protected

  def load_user
    @user = User.find current_user.id
    authorize! :edit, @user
  end
end
