require "html_truncator"

class News < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :body, :teaser, :title, :published_at, :internal

  scope :published,   where('published_at IS NOT NULL AND published_at <= ?', DateTime.now)
  scope :ffa,         where(:internal => false)

  before_validation :find_teaser

  validates :title,   :presence => true
  validates :body,    :presence => true
  validates :teaser,  :presence => true, :allow_blank => true, :allow_nil => true

  def to_param
    [id, self.slugify].join('-')
  end

  def published?
    not self.published_at.nil? and self.published_at <= DateTime.now
  end

  protected

  def find_teaser
    # Let's take the first 100 Words
    self.teaser = HTML_Truncator.truncate(self.body, 100)
  end

  def slugify
    slug = self.title
    slug.gsub!(/%/, ' prozent')
    slug.gsub!(/€/, ' euro')
    slug.parameterize
  end
end
