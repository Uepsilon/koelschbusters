class Admin::NewsController < Admin::ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /news
  # GET /news.json
  def index
  end

  # GET /news/1
  # GET /news/1.json
  def show
  end

  # GET /news/new
  # GET /news/new.json
  def new
  end

  # GET /news/1/edit
  def edit
  end

  # POST /news
  # POST /news.json
  def create
    if @news.save
      redirect_to :admin_news_index
    else
      render :new
    end
  end

  # PUT /news/1
  # PUT /news/1.json
  def update
    if @news.update_attributes params[:news]
      redirect_to :admin_news_index
    else
      render :new
    end
  end

  # DELETE /news/1
  # DELETE /news/1.json
  def destroy
    @news.destroy

    redirect_to :admin_news_index
  end
end
