class Ckeditor::PicturesController < Ckeditor::ApplicationController
  before_filter :find_asset, :only => [:destroy, :show]

  def index
    @pictures = Ckeditor.picture_model.find_all(ckeditor_pictures_scope)

    respond_with(@pictures)
  end

  def show
    if can? :read, @picture
      send_file @picture.data.path(params[:style]), :type => @picture.data_content_type, :disposition => 'inline'
    else
      render :nothing => true
    end
  end

  def create
    @picture = Ckeditor::Picture.new
    respond_with_asset(@picture)
  end

  def destroy
    @picture.destroy
    respond_with(@picture, :location => pictures_path)
  end

  protected

    def find_asset
      Rails.logger.debug params.inspect

      @picture = Ckeditor.picture_model.get!(params[:id])
    end

    def authorize_resource
      model = (@picture || Ckeditor::Picture)
      @authorization_adapter.try(:authorize, params[:action], model)
    end
end