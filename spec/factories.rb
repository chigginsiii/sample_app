FactoryGirl.define do
  factory :user do
    name "Testy McTest"
    email "test@test.com"
    password "testy!"
    password_confirmation "testy!"
  end
end
