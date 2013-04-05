class News < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :body, :slug, :teaser, :title

  before_validation :find_teaser

  validates :title,   :presence => true
  validates :slug,    :presence => true, :uniqueness => true
  validates :body,    :presence => true
  validates :teaser,  :presence => true, :allow_blank => true, :allow_nil => true

  def to_param
    slug
  end

  protected

  def find_teaser
    self.teaser = self.body if teaser.nil?
  end
end
