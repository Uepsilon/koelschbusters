class GalleriesController < ApplicationController
  before_filter :load_galleries, only: :index
  load_and_authorize_resource

  def index
  end

  def show
    if user_signed_in?
      @pictures = @gallery.pictures
    else
      @pictures = @gallery.public_pictures
    end
  end

  private

  def load_galleries
    @galleries = Gallery.select('galleries.*, MAX(pictures.created_at) AS latest_pic').joins(:pictures).order('latest_pic DESC').group('galleries.id')
    if user_signed_in?
      @galleries = @galleries.with_pictures
    else
      @galleries = @galleries.with_public_pictures
    end
  end
end
