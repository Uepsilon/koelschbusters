FactoryGirl.define do
  factory :news do
    sequence(:title)  {|n| "Random News Title #{n}" }
    body              { Forgery::LoremIpsum.paragraphs(5) }
    internal          false
    published_at      DateTime.now - 1.day

    user

    trait :members_only do
      internal        true
    end

    trait :unpublished do
      published_at    nil
    end

    trait :upcoming do
      published_at    DateTime.now + 1.day
    end
  end
end
