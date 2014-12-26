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

  has_many :pictures, dependent: :destroy, order: "created_at ASC"
  attr_accessible :title

  validates :title, presence: true

  default_scope order(:position)

  before_create :set_position

  def to_param
    [id, self.slugify].join('-')
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

  protected

  def slugify
    slug = Slugify.slugify self.title
  end
end
