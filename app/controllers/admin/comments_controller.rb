class Admin::CommentsController < Admin::ApplicationController
  load_and_authorize_resource

  add_breadcrumb I18n.t('links.comments.index'), [:admin, :comments]

  def index
    @comments = @comments.inactive.paginate(page: params[:page])
  end

  def activate
    @comment.activate!

    respond_to do |format|
      format.html{ redirect_to admin_comments, notice: 'Kommentar aktiviert'}
      format.js { render :activate }
    end
  end

  def deactivate
    @comment.deactivate!

    respond_to do |format|
      format.html{ redirect_to admin_comments, notice: 'Kommentar deaktiviert'}
      format.js { render :deactivate }
    end
  end
end
