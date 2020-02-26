# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create([
  { name: "Shafrazi", email: "shafrazi@live.com", password: "foobar", password_confirmation: "foobar" },
  { name: "Umesha", email: "umesha@live.com", password: "foobar", password_confirmation: "foobar" },
  { name: "Shiffa", email: "shiffa@live.com", password: "foobar", password_confirmation: "foobar" },
  { name: "Charuki", email: "charuki@live.com", password: "foobar", password_confirmation: "foobar" },
])

50.times do |n|
  name = Faker::Name.name
  email = "user-#{n}@email.com"
  password = "foobar"

  User.create(name: name, email: email, password: password, password_confirmation: password)
end

users = User.order(:created_at).take(40)
10.times do
  content = Faker::Lorem.sentence(word_count: 10)
  users.each do |user|
    user.posts.create!(content: content)
  end
end

users_1_20 = User.order(:created_at).take(20)
users_21_40 = User.last(20)
users_1_20.each do |user|
  users_21_40.each do |other_user|
    user.add_friend(other_user)
  end
end
