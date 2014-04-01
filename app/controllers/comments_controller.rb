# encoding: UTF-8
class CommentsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :news

  def create
    @comment.news = @news
    @comment.user = current_user if user_signed_in?
    if @comment.save
      notice = "Der Kommentar wurde erstellt."
      notice += " Allerdings muss er von uns persönlich freigeschaltet werden." unless user_signed_in?
      redirect_to @comment.news, notice: notice
    end
  end

  def edit
  end

  def update
    if @comment.update_attributes params[:comment]
      redirect_to @comment.news, notice: "Der Kommentar wurde aktualisiert."
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy

    redirect_to @comment.news, notice: "Der Kommentar wurde gelöscht."
  end
end
