class NewsController < ApplicationController
  load_and_authorize_resource

  def index
    @news = @news.published
  end

  def show
     raise ActiveRecord::RecordNotFound unless @news.published?
  end
end
