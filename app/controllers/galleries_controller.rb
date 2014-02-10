class GalleriesController < ApplicationController
  before_filter :load_galleries, only: :index
  load_and_authorize_resource

  def index
    @galleries = @galleries.order("created_at DESC")
  end

  def show
    if user_signed_in?
      @pictures = @gallery.pictures.order("created_at DESC")
    else
      @pictures = @gallery.public_pictures.order("created_at DESC")
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
