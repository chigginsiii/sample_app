namespace :db do
  desc "Fill database with sample data."
  task populate: :environment do             # rake db:populate with access to RAILS_ENV var
    make_users
    make_content
    make_relationships
  end
end

def make_users
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

def make_content
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content)}
  end
end

def make_relationships
  users = User.all
  user  = User.first
  followed_users = users[2..50]
  followers      = users[4..41]
  # ah, okay, userprime's gonna follow 49 users
  followed_users.each { |fu| user.follow!(fu) }
  # and 37 users are gonna follow prime. got it.
  followers.each      { |fu| fu.follow!(user) }
end
