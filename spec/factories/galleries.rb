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
    sequence (:title) { |i| "Gallery#{i}" }
  end

  factory :gallery_with_pictures, parent: :gallery do
    after(:create) do |gallery|
      FactoryGirl.create(:picture, gallery: gallery)
      FactoryGirl.create(:picture, :public, gallery: gallery)
    end
  end

  factory :gallery_with_internal_pictures_only, parent: :gallery do
    after(:create) do |gallery|
      2.times do
        FactoryGirl.create(:picture, gallery: gallery)
      end
    end
  end
end
