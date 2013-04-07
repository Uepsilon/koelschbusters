class NewsController < ApplicationController
  load_and_authorize_resource

  def index
    p 'Hello World'
    Rails.logger.debug @news.inspect
  end

  def show
  end
end
