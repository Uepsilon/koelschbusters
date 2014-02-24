class Picture < ActiveRecord::Base

  Paperclip.interpolates :gallery_id do |attachment, style|
    attachment.instance.gallery_id
  end

  STYLES = %w[original thumb maxithumb]

  belongs_to :gallery

  has_attached_file :picture,
                    :default_style => :original,
                    :url  => "/galerie/:gallery_id/bild/:id/:style.:extension",
                    :path => ":rails_root/shared/:rails_env/pictures/:id/:style/:basename.:extension",
                    :styles => { thumb: '200x150>'  }

  attr_accessible :internal, :picture

  validates_attachment_size         :picture, less_than: 2.megabytes
  validates_attachment_presence     :picture
  validates_attachment_content_type :picture, content_type: ['image/jpeg', 'image/png', 'image/gif']

  def public?
    not self.internal?
  end

  def publish
    self.internal = false
    self.save
  end

  def unpublish
    self.internal = true
    self.save
  end
end
