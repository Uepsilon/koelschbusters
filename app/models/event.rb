# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  internal    :boolean          default(TRUE)
#  title       :string           not null
#  description :text             not null
#  starts_at   :datetime         not null
#  ends_at     :datetime         not null
#  location    :string           not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Event < ActiveRecord::Base
  default_scope -> { where('ends_at > ?', Time.now).order(starts_at: :asc, ends_at: :asc) }

  has_many :user_events
  has_many :users, through: :user_events
  has_many :participants,
           -> { where 'user_events.participation' => true },
           through: :user_events,
           class_name: 'User',
           source: :user

  has_many :declinings,
           -> { where 'user_events.participation' => false },
           through: :user_events,
           class_name: 'User',
           source: :user

  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :location, presence: true

  before_validation :ensure_end
  after_create :notify_members

  def event_coordinates
    Geocoder.coordinates location unless location.blank?
  end

  private

  def ensure_end
    self.ends_at = starts_at if ends_at.blank?
  end

  def notify_members
    User.all.each do |user|
      EventMailer.notify(user, self).deliver_now
    end
  end
end
