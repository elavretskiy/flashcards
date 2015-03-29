FactoryGirl.define do
  factory :user do
    email 'test@test.by'
    password '12345'

    transient do
      cards_count 1
    end

    factory :user_with_cards do
      after(:create) do |user, evaluator|
        create_list(:card, evaluator.cards_count, user: user)
      end
    end
  end
end