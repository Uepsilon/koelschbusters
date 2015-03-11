class Admin::CategoriesController < Admin::ApplicationController
  load_and_authorize_resource
  add_breadcrumb I18n.t('links.categories.index'), [:admin, :categories]

  def index
    @categories = @categories.order(:title)
  end

  def new
    add_breadcrumb I18n.t('links.categories.new'), new_admin_category_path
  end

  def create
    add_breadcrumb I18n.t('links.categories.new'), new_admin_category_path

    if @category.save
      flash[:notice] = I18n.t('flash.categories.created')
      redirect_to :admin_categories
    else
      render :new
    end
  end

  def edit
    add_breadcrumb I18n.t('links.categories.edit'), [:edit, :admin, @category]
  end

  def update
    add_breadcrumb I18n.t('links.categories.edit'), [:edit, :admin, @category]

    if @category.update category_params
      flash[:notice] = I18n.t('flash.categories.updated')
      redirect_to :admin_categories
    else
      render :edit
    end
  end

  def destroy
    @category.delete
    flash[:notice] = I18n.t('flash.categories.deleted')

    redirect_to :admin_categories
  end

  private

  def category_params
    params.require(:category).permit(:title)
  end
end
