class Admin::NewsCommentsController < Admin::ApplicationController
  load_and_authorize_resource

  add_breadcrumb I18n.t('links.news_comments.index'), [:admin, :news_comments]

  def index
    @news_comments = @news_comments.inactive.paginate(page: params[:page])
  end

  def activate
    @news_comment.activate!

    respond_to do |format|
      format.html{ redirect_to admin_news_comments, notice: "Kommentar aktiviert"}
      format.js { render :activate }
    end
  end

  def deactivate
    @news_comment.deactivate!

    respond_to do |format|
      format.html{ redirect_to admin_news_comments, notice: "Kommentar deaktiviert"}
      format.js { render :deactivate }
    end
  end
end
