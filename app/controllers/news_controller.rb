class NewsController < ApplicationController
  load_and_authorize_resource :only => :index
  before_filter :load_resource, :only => :show

  def index
  end

  def show
  end

  protected

  def load_resource
    @news = News.find_by_slug! params[:id]
  end
end
