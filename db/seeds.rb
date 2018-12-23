# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[
  { email: 'user@user.ua', password: 'password' },
  { email: 'user2@user.ua', password: 'password2' }
].each do |user|
  User.find_or_create_by!(email: user[:email]) do |new_user|
    new_user.password = user[:password]
  end
end

[
  { name: 'Trip to a new place', user_id: 1 },
  { name: 'Another project', user_id: 1 },
  { name: 'Project number 3', user_id: 2 }
].each do |project|
  Project.find_or_create_by!(project)
end

[
  { name: 'Buy airway tickets', project_id: 1 },
  { name: 'Book an apartment', project_id: 1 },
  { name: 'Buy railway and bus tickets', project_id: 1 },
  { name: 'Choose must-seen places', project_id: 1 },
  { name: 'Check-in on flight', project_id: 1 },
  { name: 'Another task 111', project_id: 2 },
  { name: 'Another one task 424', project_id: 2 },
  { name: 'Very important task', project_id: 2 },
  { name: 'Go to the cinema', project_id: 3 },
  { name: 'Drink coffee', project_id: 3, done: true }
].each do |task|
  Task.find_or_create_by!(task)
end
