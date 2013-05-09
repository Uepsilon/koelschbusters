class Admin::GalleriesController < Admin::ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    if @gallery.save
      flash[:notice] = "Gallerie wurde erstellt."
      redirect_to :admin_galleries
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @gallery.update_attributes params[:gallery]
      flash[:notice] = "Gallerie wurde aktualisiert."
      redirect_to :admin_galleries
    else
      render :edit
    end
  end

  def destroy
    @gallery.destroy
    flash[:notice] = "Gallerie wurde gelöscht."
    redirect_to :admin_galleries
  end
end
