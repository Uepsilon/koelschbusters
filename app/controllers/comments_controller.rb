# encoding: UTF-8
class CommentsController < ApplicationController
  load_and_authorize_resource :news
  load_and_authorize_resource :comment, through: :news

  def create
    @comment.commentable = @news
    @comment.user = current_user if user_signed_in?

    return unless @comment.save

    notice = 'Der Kommentar wurde erstellt.'
    notice += ' Allerdings muss er von uns persönlich freigeschaltet werden.' unless user_signed_in?
    redirect_to @comment.commentable, notice: notice
  end

  def edit
  end

  def update
    if @comment.update comment_params
      redirect_to @comment.commentable, notice: 'Der Kommentar wurde aktualisiert.'
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy

    redirect_to @comment.commentable, notice: 'Der Kommentar wurde gelöscht.'
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :username)
  end
end
