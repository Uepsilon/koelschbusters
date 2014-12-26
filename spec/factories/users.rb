# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  first_name             :string(255)      default(""), not null
#  last_name              :string(255)      default(""), not null
#  street                 :string(255)
#  houseno                :string(255)
#  zipcode                :string(255)
#  city                   :string(255)
#  phone                  :string(255)
#  mobile                 :string(255)
#  member_active          :boolean          default(FALSE)
#  role                   :string(255)      default("member"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  twitter_uid            :string(255)
#  twitter_name           :string(255)
#  facebook_uid           :string(255)
#  facebook_name          :string(255)
#  google_uid             :string(255)
#  google_name            :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :user do
    first_name  "Mister"
    last_name "Simpson"
    role "member"

    sequence(:email) { |i| "random#{i}@email.com" }

    phone       "01234567890"
    mobile      "09876543210"

    street      "Evergreen Terrace"
    houseno     "742a"
    zipcode     "12345"
    city        "Springfield"

    member_active true

    password    'Test12345'

    trait :admin do
      last_name "Burns"
      role "admin"
    end

    trait :management do
      last_name "Smithers"
      role "management"
    end

    trait :inactive do
      member_active false
    end

    before(:create) { |user| user.skip_confirmation! }
    after(:create) { |user| user.skip_reconfirmation! }
  end
end
