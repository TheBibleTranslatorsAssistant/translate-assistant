# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = [
  'ardell@gmail.com',
  'sackman.nicholas@gmail.com',
].map do |email|
  {
    email: email,
    password: '12345678',
  }
end
User.create(users)

