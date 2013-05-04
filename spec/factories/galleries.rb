# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gallery do
    sequence (:title) { |i| "Gallery#{i}" }
  end

  factory :gallery_with_pictures, parent: :gallery do
    after(:create) do |gallery|
      FactoryGirl.create(:picture, gallery: gallery)
      FactoryGirl.create(:picture, internal: true, gallery: gallery)
    end
  end
end
