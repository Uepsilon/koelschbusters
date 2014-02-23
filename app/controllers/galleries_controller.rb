class GalleriesController < ApplicationController
  before_filter :load_galleries, only: :index
  load_and_authorize_resource

  def index
  end

  def show
    @galleries = Gallery.select('galleries.*, MAX(pictures.created_at) AS latest_pic').joins(:pictures).order('latest_pic').group('galleries.id')

    if user_signed_in?
      @pictures = @gallery.pictures
    else
      @pictures = @gallery.public_pictures
    end
  end

  protected

  def load_galleries
    if user_signed_in?
      @galleries = Gallery.with_pictures
    else
      @galleries = Gallery.with_public_pictures
    end
  end
end
