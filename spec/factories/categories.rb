FactoryGirl.define do
  factory :category do
    sequence (:title) { |i| "TestKategorie#{i}" }
  end
end
