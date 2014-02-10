class NewsController < ApplicationController
  load_and_authorize_resource

  def index
    @news = @news.published.order("published_at DESC").paginate(page: params[:page])
  end

  def show
  end
end
