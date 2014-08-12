namespace :db do
  desc "Fill database with sample data."
  task populate: :environment do             # rake db:populate with access to RAILS_ENV var
    User.create!(
      name: 'Testy McTest',
      email: 'test_prime@testy.com',
      password: 'testnumprime',
      password_confirmation: 'testnumprime',
      admin: true
    )
    99.times do |n|
      name = Faker::Name.name
      email = "test_#{n}@testy.com"
      User.create!(
        name: name,
        email: "test_#{n}@testy.com",
        password: "testnum_#{n}",
        password_confirmation: "testnum_#{n}"
      )
    end
  end
end
