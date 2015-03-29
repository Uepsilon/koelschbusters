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

FactoryGirl.define do
  factory :event do
    sequence(:title) { |i| "Test Event#{i}" }
    starts_at Time.now
    ends_at Time.now + 1.day
    description { Forgery::LoremIpsum.paragraphs(1) }
    location 'Kölner Dom'
  end
end
