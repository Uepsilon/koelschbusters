require "html_truncator"

class News < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :body, :teaser, :title, :published_at

  scope :published, where('published_at IS NOT NULL')

  before_validation :find_teaser

  validates :title,   :presence => true
  validates :body,    :presence => true
  validates :teaser,  :presence => true, :allow_blank => true, :allow_nil => true

  def to_param
    [id, self.slugify].join('-')
  end

  protected

  def find_teaser
    # Let's take the first 25 Words
    self.teaser = HTML_Truncator.truncate(self.body, 100)
  end

  def slugify
    slug = self.title
    slug.gsub!(/%/, ' prozent')
    slug.parameterize
  end
end
