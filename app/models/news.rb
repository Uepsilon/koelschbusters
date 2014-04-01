# encoding: UTF-8
require "html_truncator"

class News < ActiveRecord::Base
  include Slugify

  belongs_to  :user
  belongs_to  :category
  has_many    :comments,  as: :commentable, dependent: :destroy

  attr_accessible :user, :body, :teaser, :title, :published_at, :internal, :category_id

  scope :published,   -> { where("news.published_at <= ?", Time.now)}
  scope :ffa,         where(:internal => false)

  before_validation :find_teaser

  self.per_page = 10

  validates :title,   :presence => true
  validates :body,    :presence => true
  validates :teaser,  :presence => true, :allow_blank => true, :allow_nil => true
  validates :user_id, :presence => true

  def to_param
    [id, self.slugify].join('-')
  end

  def published?
    not self.published_at.nil? and self.published_at <= Time.now
  end

  def public?
    not self.internal?
  end

  protected

  def find_teaser
    # Let's take the first 100 Words
    self.teaser = HTML_Truncator.truncate(self.body, 100)
  end

  def slugify
    slug = Slugify.slugify self.title
  end
end
