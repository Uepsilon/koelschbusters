FactoryGirl.define do
  factory :contact do
    skip_create

    email 'spec@example.com'
    name 'Spec Test'
    subject 'Spec Test Subject'
    text 'Lorem Ipsum'
  end
end
