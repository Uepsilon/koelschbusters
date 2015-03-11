class Admin::GalleriesController < Admin::ApplicationController
  load_and_authorize_resource

  add_breadcrumb I18n.t('links.gallery.index'), [:admin, :galleries]

  def new
    add_breadcrumb I18n.t('links.gallery.new'), [:new, :admin, :gallery]
  end

  def create
    add_breadcrumb I18n.t('links.gallery.new'), [:new, :admin, :gallery]

    if @gallery.save
      flash[:notice] = 'Gallerie wurde erstellt.'
      redirect_to :admin_galleries
    else
      render :new
    end
  end

  def edit
    add_breadcrumb I18n.t('links.gallery.edit'), [:edit, :admin, @gallery]
  end

  def update
    add_breadcrumb I18n.t('links.gallery.edit'), [:edit, :admin, @gallery]

    if @gallery.update gallery_params
      flash[:notice] = 'Gallerie wurde aktualisiert.'
      redirect_to :admin_galleries
    else
      render :edit
    end
  end

  def destroy
    @gallery.destroy
    flash[:notice] = 'Gallerie wurde gelöscht.'
    redirect_to :admin_galleries
  end

  def sort
    params[:positions].each do |gallery_id, position|
      Gallery.find(gallery_id).update_attribute(:position, position)
    end

    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end

  private

  def gallery_params
    params.require(:gallery).permit(:title)
  end
end
