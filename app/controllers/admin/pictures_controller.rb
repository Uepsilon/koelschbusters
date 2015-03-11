class Admin::PicturesController < Admin::ApplicationController
  load_and_authorize_resource :gallery
  load_and_authorize_resource :picture, through: :gallery

  add_breadcrumb I18n.t('links.gallery.index'), [:admin, :galleries]


  def index
    add_breadcrumb @gallery.title, [:admin, @gallery, :pictures]
  end

  def new
    add_breadcrumb @gallery.title, [:admin, @gallery, :pictures]
    add_breadcrumb I18n.t('links.picture.new'), [:new, :admin, @gallery, :picture]
  end

  def create
    add_breadcrumb @gallery.title, [:admin, @gallery, :pictures]
    add_breadcrumb I18n.t('links.picture.new'), [:new, :admin, @gallery, :picture]

    if @picture.save
      flash[:notice] = 'Bild wurde erstellt.'
      redirect_to [:admin, @gallery, :pictures]
    else
      render :new
    end
  end

  def edit
    add_breadcrumb @gallery.title, [:admin, @gallery, :pictures]
    add_breadcrumb I18n.t('links.picture.edit'), [:edit, :admin, @gallery, @picture]
  end

  def update
    add_breadcrumb @gallery.title, [:admin, @gallery, :pictures]
    add_breadcrumb I18n.t('links.picture.edit'), [:edit, :admin, @gallery, @picture]

    if @picture.update picture_params
      flash[:notice] = 'Bild wurde aktualisiert.'
      redirect_to [:admin, @gallery, :pictures]
    else
      render :edit
    end
  end

  def destroy
    @picture.destroy
    flash[:notice] = 'Bild wurde gelöscht.'
    redirect_to [:admin, @gallery, :pictures]
  end

  def publish
    @picture.publish
  end

  def unpublish
    @picture.unpublish
  end

  def sort
    gallery = Gallery.find params[:gallery_id]

    params[:positions].each do |picture_id, position|
      gallery.pictures.find(picture_id).update_attribute(:position, position)
    end

    respond_to do |format|
      format.json { render json: {success: true } }
    end
  end

  private

  def picture_params
    params.require(:picture).permit(:internal, :picture)
  end
end
