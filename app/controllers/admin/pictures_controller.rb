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
      flash[:notice] = "Bild wurde erstellt."
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

  def publish
    @picture.publish
    flash[:notice] = "Bild wurde veröffentlich."
    redirect_to [:admin, @gallery, :pictures]
  end

  def unpublish
    @picture.unpublish
    Rails.logger.debug @picture.inspect
    flash[:notice] = "Bild wurde zurück gezogen."
    redirect_to [:admin, @gallery, :pictures]
  end
end
