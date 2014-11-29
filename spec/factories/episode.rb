FactoryGirl.define do
  factory :episode do
    sequence(:number) { |n| "第#{n}話" }
    sequence(:title)  { |n| "Yes! プリキュア#{n}" }

    before(:create) { |e| e.work = e.work.presence || create(:work, :with_item) }
  end
end
