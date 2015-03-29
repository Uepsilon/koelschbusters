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

FactoryGirl.define do
  factory :user_event do
    event
    user
    participation false
  end
end
