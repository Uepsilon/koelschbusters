class NewsController < ApplicationController
  load_and_authorize_resource

  def index
    @news = @news.published.all
  end

  def show
  end
end
