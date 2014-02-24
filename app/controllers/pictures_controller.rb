class PicturesController < ApplicationController
  load_and_authorize_resource
  before_filter :check_gallery, only: :show

  def show
    style = params[:style]
    style = :original if style.nil? or not Picture::STYLES.include? style
    send_file @picture.picture.path(style), :type => @picture.picture_content_type, :disposition => 'inline'
  end

  def check_gallery
    gallery = Gallery.find params[:gallery_id]

    if gallery != @picture.gallery
      raise CanCan::AccessDenied.new("Not authorized!", :read, gallery)
    else
      authorize! :read, gallery
    end
  end
end
