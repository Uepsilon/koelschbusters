# encoding: UTF-8
# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  include Slugify

  has_many :news

  attr_accessor :slug
  attr_accessible :title, :slug

  validates :title, presence: true, uniqueness: true

  def to_param
    [id, self.slugify].join('-')
  end

  protected

  def slugify
    slug = Slugify.slugify  self.title
  end
end
