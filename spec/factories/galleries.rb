# == Schema Information
#
# Table name: galleries
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gallery do
    sequence(:title) { |i| "Gallery#{i}" }

    transient do
      pictures_count 2
    end

    factory :gallery_with_pictures do
      after(:create) do |gallery|
        create :picture, gallery: gallery
        create :public_picture, gallery: gallery
      end
    end

    factory :gallery_with_internal_pictures_only do
      after(:create) do |gallery, evaluator|
        create_list :picture, evaluator.pictures_count, gallery: gallery
      end
    end
  end
end
