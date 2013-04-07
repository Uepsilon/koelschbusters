class NewsController < ApplicationController
  load_and_authorize_resource :only => :index
  before_filter :load_resource, :only => :show

  def index
  end

  def show
  end

  protected

  def load_resource
    @news = News.find_by_slug params[:id]

    if @news.nil?
      flash[:alert] = "Die von Ihnen gesuchte News konnte leider nicht gefunden werden"
      redirect_to :news_index
    end
  end
end
