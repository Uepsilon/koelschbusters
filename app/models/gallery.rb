# encoding: UTF-8
# == Schema Information
#
# Table name: galleries
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :integer
#

class Gallery < ActiveRecord::Base
  include Slugify

  has_many :pictures, -> { order created_at: :asc }, dependent: :destroy

  validates :title, presence: true

  default_scope -> { order position: :asc }

  before_create :set_position

  def to_param
    [id, slugify].join('-')
  end

  def self.with_pictures
    joins(:pictures).group('galleries.id')
  end

  def self.with_public_pictures
    joins(:pictures).where('pictures.internal = ?', false).group('galleries.id')
  end

  def public_pictures
    pictures.where(internal: false)
  end

  def internal_pictures
    pictures.where(internal: true)
  end

  def set_position
    self.position = 0
    self.position = Gallery.maximum(:position) + 1 if Gallery.maximum(:position)
  end
end
