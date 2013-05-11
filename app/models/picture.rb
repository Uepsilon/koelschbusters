class Picture < ActiveRecord::Base

  Paperclip.interpolates :gallery_id do |attachment, style|
    attachment.instance.gallery_id
  end

  STYLES = %w[original thumb]

  belongs_to :gallery

  has_attached_file :picture,
                    :default_style => :original,
                    :url  => "/galerie/:gallery_id/bild/:id/:style",
                    :path => ":rails_root/shared/pictures/:id/:style/:basename.:extension",
                    :styles => { thumb: '200>' }

  attr_accessible :internal, :picture

  validates_attachment_size         :picture, less_than: 5.megabytes
  validates_attachment_presence     :picture
  validates_attachment_content_type :picture, content_type: ['image/jpeg', 'image/png', 'image/gif']
end
