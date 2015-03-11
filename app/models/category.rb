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

  validates :title, presence: true, uniqueness: true

  def to_param
    [id, slugify].join('-')
  end

  def slug
    slugify
  end
end
