# == Schema Information
#
# Table name: pictures
#
#  id                   :integer          not null, primary key
#  internal             :boolean
#  gallery_id           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  position             :integer
#

class Picture < ActiveRecord::Base
  Paperclip.interpolates :gallery_id do |attachment, _style|
    attachment.instance.gallery_id
  end

  STYLES = %w(original thumb)

  belongs_to :gallery

  default_scope -> { order position: :asc }

  has_attached_file :picture,
                    default_style: :original,
                    url: '/galerie/:gallery_id/bild/:id/:style.:extension',
                    path: ':rails_root/shared/:rails_env/pictures/:id/:style/:basename.:extension',
                    styles: { original: '1200x1200>', thumb: '200x150>'  }

  before_create :set_position

  validates_attachment_size :picture, less_than: 5.megabytes
  validates_attachment_presence :picture
  validates_attachment_content_type :picture, content_type: ['image/jpeg', 'image/png', 'image/gif']

  validates :gallery_id, presence: true

  def public?
    !internal?
  end

  def publish
    self.internal = false
    save
  end

  def unpublish
    self.internal = true
    save
  end

  def set_position
    self.position = gallery.pictures.maximum(:position) + 1 if gallery.pictures.maximum(:position)
  end
end
