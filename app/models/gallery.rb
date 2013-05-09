class Gallery < ActiveRecord::Base
  has_many :pictures

  attr_accessible :title

  validates :title, presence: true

  def self.with_pictures
    joins(:pictures).group('galleries.id')
  end

  def self.with_public_pictures
    joins(:pictures).where('pictures.internal = ?', false).group('galleries.id')
  end

  def public_pictures
    pictures.where(internal: false)
  end
end
