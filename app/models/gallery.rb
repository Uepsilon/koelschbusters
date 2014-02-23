class Gallery < ActiveRecord::Base
  has_many :pictures, dependent: :destroy, order: "created_at ASC"
  attr_accessible :title

  validates :title, presence: true

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

  protected

  def slugify
    slug = self.title
    slug.gsub!(/%/, ' prozent')
    slug.gsub!(/€/, ' euro')
    slug.parameterize
  end
end
