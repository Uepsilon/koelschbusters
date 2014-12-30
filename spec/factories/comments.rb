# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  username         :string(255)
#  body             :text
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  activated_at     :datetime
#  commentable_id   :integer
#  commentable_type :string(255)
#

FactoryGirl.define do
  factory :comment do
    body 'Lorem Ipsum'

    factory :news_comment do
      association :commentable, factory: :news
    end

    trait :anonymous do
      username 'Roadrunner'
    end
  end
end
