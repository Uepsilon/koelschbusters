class NewsController < ApplicationController
  # before_filter :find_published, :only => :show
  load_and_authorize_resource

  def index
    @news = @news.published
  end

  def show
  end

  protected

  def find_published
    @news = News.published.find params[:id]
  end
end
