# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :user do
    first_name  "Mister"
    last_name "Simpson"
    role "member"

    email       "random@email.com"
    phone       "01234567890"
    mobile      "09876543210"

    address     "Evergreen Terrace"
    houseno     "742a"
    zipcode     "12345"
    city        "Springfield"

    member_active true

    password    'Test12345'

    trait :admin do
      last_name "Burns"
      role "admin"
    end

    trait :manager do
      last_name "Smithers"
      role "management"
    end

    trait :inactive do
      member_active false
    end
  end
end
