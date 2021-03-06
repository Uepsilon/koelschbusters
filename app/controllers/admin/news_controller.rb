class Admin::NewsController < Admin::ApplicationController
  load_and_authorize_resource

  add_breadcrumb I18n.t('breadcrumbs.news'), [:admin, :news, :index]

  def index
    @news = @news.joins(:category).where(categories: { id: params[:category] }) unless params[:category].nil?
    @news = @news.order('id DESC').paginate page: params[:page], per_page: 5
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.new'), [:new, :admin, :news]
  end

  def edit
    add_breadcrumb I18n.t('breadcrumbs.edit'), [:edit, :admin, @news]
  end

  def create
    add_breadcrumb I18n.t('breadcrumbs.new'), [:new, :admin, :news]

    @news.user = current_user
    if @news.save
      redirect_to :admin_news_index
    else
      render :new
    end
  end

  def update
    add_breadcrumb I18n.t('breadcrumbs.edit'), [:edit, :admin, @news]

    if @news.update news_params
      redirect_to :admin_news_index
    else
      render :edit
    end
  end

  def destroy
    @news.destroy
    redirect_to :admin_news_index
  end

  def publish
    if @news.update(published_at: DateTime.now)
      flash[:notice] = 'News wurde veröffentlicht.'
      expire_fragment controller: 'news', action: 'index', action_suffix: 'news'
    else
      flash[:alert] = 'News konnte nicht veröffentlicht werden.'
    end

    redirect_to :admin_news_index
  end

  def unpublish
    if @news.update(published_at: nil)
      flash[:notice] = 'Veröffentlichung der News wurde zurück gezogen.'
      expire_fragment controller: 'news', action: 'index', action_suffix: 'news'
    else
      flash[:alert] = 'Veröffentlichung der News konnte nicht zurück gezogen werden.'
    end

    redirect_to :admin_news_index
  end

  private

  def news_params
    params.require(:news).permit(:body, :teaser, :title, :internal, :category_id)
  end
end
