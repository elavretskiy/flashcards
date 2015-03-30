FactoryGirl.define do
  factory :user do
    email 'test@test.com'
    password '12345'
    password_confirmation '12345'

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