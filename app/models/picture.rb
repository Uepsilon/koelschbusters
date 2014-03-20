class Picture < ActiveRecord::Base

  Paperclip.interpolates :gallery_id do |attachment, style|
    attachment.instance.gallery_id
  end

  STYLES = %w[original thumb]

  belongs_to :gallery

  default_scope order(:position)

  has_attached_file :picture,
                    :default_style => :original,
                    :url  => "/galerie/:gallery_id/bild/:id/:style.:extension",
                    :path => ":rails_root/shared/:rails_env/pictures/:id/:style/:basename.:extension",
                    :styles => { original: '1200x1200>', thumb: '200x150>'  }

  attr_accessible :internal, :picture

  before_create :set_position

  validates_attachment_size         :picture, less_than: 5.megabytes
  validates_attachment_presence     :picture
  validates_attachment_content_type :picture, content_type: ['image/jpeg', 'image/png', 'image/gif']

  validates :gallery_id, presence: true

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

  def set_position
    self.position
    self.position = self.gallery.pictures.maximum(:position) + 1 if self.gallery.pictures.maximum(:position)
  end
end
