class NewsController < ApplicationController
  load_and_authorize_resource

  def index
    @news = @news.published.order("published_at DESC").all
  end

  def show
  end
end
