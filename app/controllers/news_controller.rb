class NewsController < ApplicationController
  load_and_authorize_resource

  def index
    unless params[:category].nil?
     @category = Category.find params[:category]
      @news = @news.joins(:category).where(categories: {id: params[:category]})
    end
    @news = @news.published.order("published_at DESC").paginate(page: params[:page])

    fresh_when last_modified: @news.maximum(:published_at), public: true
  end

  def show
  end
end
