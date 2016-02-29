class GalleryDecorator < Draper::Decorator
  delegate_all

  def preview_picture
    if h.user_signed_in?
      pictures.first.picture
    else
      public_pictures.first.picture
    end
  end
end
