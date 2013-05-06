include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :picture do
    sequence(:picture) do |i|
      fixture_file_upload(Rails.root.join('spec', 'factories', 'pictures', "#{(i % 4)}.png"))
    end

    internal false
    gallery
  end
end
