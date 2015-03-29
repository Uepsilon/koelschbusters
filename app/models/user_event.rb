# == Schema Information
#
# Table name: user_events
#
#  id            :integer          not null, primary key
#  event_id      :integer          not null
#  user_id       :integer          not null
#  participation :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true
end
