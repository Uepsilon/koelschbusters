# == Schema Information
#
# Table name: pictures
#
#  id                   :integer          not null, primary key
#  internal             :boolean
#  gallery_id           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  position             :integer
#

include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :picture do
    sequence(:picture) do |i|
      fixture_file_upload(Rails.root.join('spec', 'factories', 'pictures', "#{(i % 4)}.png"), 'image/png')
    end

    internal true
    gallery

    factory :oversized_picture do
      picture { fixture_file_upload(Rails.root.join('spec', 'factories', 'pictures', 'oversized.png'), 'image/png') }
    end

    factory :public_picture do
      internal false
    end
  end
end
