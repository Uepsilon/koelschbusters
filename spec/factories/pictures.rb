include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :picture do
    sequence(:picture) do |i|
      fixture_file_upload(Rails.root.join('spec', 'factories', 'pictures', "#{(i % 4)}.png"), 'image/png')
    end

    internal true
    gallery

    trait :oversized do
      picture { fixture_file_upload(Rails.root.join('spec', 'factories', 'pictures', 'oversized.png'), 'image/png') }
    end

    trait :public do
      internal false
    end
  end
end
