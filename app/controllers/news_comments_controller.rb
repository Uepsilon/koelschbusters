class NewsCommentsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :news

  def create
    @news_comment.news = @news
    @news_comment.user = current_user if user_signed_in?
    if @news_comment.save
      redirect_to @news_comment.news, notice: "Der Kommentar wurde erstellt."
    end
  end

  def edit
  end

  def update
    if @news_comment.update_attributes params[:news_comment]
      redirect @news_comment.news, notice: "Der Kommentar wurde aktualisiert."
    else
      render :edit
    end
  end

  def delete
    @news_comment.destroy

    redirect_to @news_comment.news, notice: "Der Kommentar wurde gelöscht."
  end
end
