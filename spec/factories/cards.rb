FactoryGirl.define do
  factory :card do
    original_text 'дом'
    translated_text 'house'
    user
  end
end