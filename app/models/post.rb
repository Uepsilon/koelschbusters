class Post < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :body, :slug, :teaser, :title

  validates :title,   :presence => true
  validates :slug,    :presence => true, :uniqueness => true
  validates :body,    :presence => true
  validates :teaser,  :presence => true, :allow_blank => true, :allow_nil => true
end
