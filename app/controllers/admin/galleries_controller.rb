class Admin::GalleriesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    if @gallery.save
      redirect_to :admin_galleries
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @gallery.update_attributes params[:gallery]
      redirect_to :admin_galleries
    else
      render :edit
    end
  end

  def destroy
    @gallery.destroy
    redirect_to :admin_galleries
  end
end
