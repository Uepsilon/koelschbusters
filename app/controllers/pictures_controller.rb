class PicturesController < ApplicationController
  load_and_authorize_resource

  def show
    style = params[:id].split('_').pop
    style = :original unless Picture::STYLES.include? style
    send_file @picture.picture.path(style), :type => @picture.picture_content_type, :disposition => 'inline'
  end
end
