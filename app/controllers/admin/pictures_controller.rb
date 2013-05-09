class Admin::PicturesController < Admin::ApplicationController
  load_and_authorize_resource :gallery
  load_and_authorize_resource :picture, through: :gallery

  def index
  end

  def new
  end

  def create
    if @picture.save
      flash[:notice] = "Bild wurde erstellt."
      redirect_to [:admin, @gallery, :pictures]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @picture.update_attributes params[:picture]
      flash[:notice] = "Bild wurde aktualisiert."
      redirect_to [:admin, @gallery, :pictures]
    else
      render :edit
    end
  end

  def destroy
    @picture.destroy
    flash[:notice] = "Bild wurde gelöscht."
    redirect_to [:admin, @gallery, :pictures]
  end
end
