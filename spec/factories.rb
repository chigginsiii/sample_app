FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "Testy_#{n} Test" }
    sequence(:email) {|n| "test_#{n}@test.com" }
    password "testy!"
    password_confirmation "testy!"

    factory :admin do
      admin true
    end
  end
end
