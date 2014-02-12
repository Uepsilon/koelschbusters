class Category < ActiveRecord::Base
  has_many :news

  attr_accessor :slug
  attr_accessible :title, :slug

  validates :title, presence: true, uniqueness: true

  def to_param
    [id, self.slugify].join('-')
  end

  protected

  def slugify
    slug = self.title
    slug.gsub!(/%/, ' prozent')
    slug.gsub!(/€/, ' euro')
    slug.parameterize
  end
end
