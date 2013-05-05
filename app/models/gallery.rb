class Gallery < ActiveRecord::Base
  has_many :pictures

  # scope :with_images_by_role -> |role| joins(:pictures).where('picture.internal = ?', false)

  attr_accessible :title

  validates :title, presence: true
end
