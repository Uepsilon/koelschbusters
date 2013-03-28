class UsersController < ApplicationController
  before_filter :authenticate_user!

  before_filter :load_user


  def show

  end

  def edit

  end

  def update

  end

  protected

  def load_user
    @user = current_user
    authorize! :edit, @user
  end
end
