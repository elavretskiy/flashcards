FactoryGirl.define do
  factory :card do
    original_text 'дом'
    translated_text 'house'
    review_step 1
    user
    block
  end
end