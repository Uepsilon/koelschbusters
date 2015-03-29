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
  has_many :user_events
  has_many :users, through: :user_events
  has_many :participants,
           -> { where 'user_events.participation' => true },
           through: :user_events,
           class_name: 'User',
           source: :user

  validates :internal, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :location, presence: true
end
