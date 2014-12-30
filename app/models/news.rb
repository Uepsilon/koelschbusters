# encoding: UTF-8
# == Schema Information
#
# Table name: news
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  body         :text
#  teaser       :text
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  published_at :datetime
#  internal     :boolean          default(FALSE)
#  category_id  :integer
#  notified_at  :time
#

require 'html_truncator'

class News < ActiveRecord::Base
  include Slugify

  belongs_to :user
  belongs_to :category
  has_many :comments, as: :commentable, dependent: :destroy

  attr_accessible :user, :body, :teaser, :title, :published_at, :internal, :category_id

  scope :published, -> { where('news.published_at <= ?', Time.now) }
  scope :ffa, where(internal: false)

  before_validation :find_teaser

  self.per_page = 10

  validates :title, presence: true
  validates :body, presence: true
  validates :teaser, presence: true, allow_blank: true, allow_nil: true
  validates :user_id, presence: true

  after_find :notify_members

  def to_param
    [id, slugify].join('-')
  end

  def published?
    published_at.present? && published_at <= Time.now
  end

  def public?
    !internal?
  end

  def notified?
    notified_at.present?
  end

  protected

  def notify_members
    return if public? || !published? || notified?

    User.all.each do |user|
      NewsMailer.notification(user, self).deliver
    end

    self.notified_at = Time.now
    self.save!
  end

  def find_teaser
    # Let's take the first 100 Words
    self.teaser = HTML_Truncator.truncate(body, 100)
  end

  def slugify
    Slugify.slugify title
  end
end
