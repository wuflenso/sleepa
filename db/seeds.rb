# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "start seeding database..."

puts "clearing up existing database..."
Rails.cache.clear
User.delete_all
Follower.delete_all
Sleep.delete_all
ActiveRecord::Base.connection.execute("ALTER TABLE users AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE followers AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE sleeps AUTO_INCREMENT = 1")

# generate users
puts "generating users..."

100.times do |i|
  User.create(name: "User ##{i}")
end

# generate follows
puts "generating followers..."

# user with small following - user id 2
(3..10).each do |i|
  Follower.follow(User.find_or_create_by(id: i).id, User.find_or_create_by(id: 2).id)
end

# user with lots of following - user id 1
(2..100).each do |i|
  Follower.follow(User.find(i).id, User.find_or_create_by(id: 1).id)
end

# user with small followers - user id 1
(3..10).each do |i|
  Follower.follow(User.find_or_create_by(id: 1).id, User.find_or_create_by(id: i).id)
end

# user with lots of followers - user id 2
(50..100).each do |i|
  Follower.follow(User.find_or_create_by(id: 2).id, User.find(i).id)
end

# generate sleeps for each main test users (ids 1 - 10)
# :end have to be on the next day of :start
puts "generating sleeps..."

# generate sleep for last week
sleep_duration_options = [ 4.hours, 5.hours, 6.hours, 7.hours, 8.hours, 9.hours ]
start_last_week = (DateTime.now.in_time_zone - 7.days).beginning_of_week
sleep_start_time_variations = [ 19.hours, 20.hours, 21.hours, 22.hours, 23.hours ]

[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ].each do |i|
  start_time = start_last_week
  6.times do
    start_variation = sleep_start_time_variations.sample
    params = {
      user_id: i,
      start: start_time + start_variation,
      end: start_time + start_variation + sleep_duration_options.sample
    }
    Sleep.clock_in(params)
    start_time = (start_time + 1.day).beginning_of_day
  end
end

# generate several sleeps outside last week
3.times do
  start_time = (start_last_week - 5.days).beginning_of_day
  [ 1, 2, 3, 4, 5 ].each do |i|
    start_variation = sleep_start_time_variations.sample
    params = {
      user_id: i,
      start: start_time + start_variation,
      end: start_time + start_variation + sleep_duration_options.sample
    }
    Sleep.clock_in(params)
  end
  start_time = (start_time - 30.days).beginning_of_day
end

puts "users records created: " + User.count.to_s
puts "followers records created: " + Follower.count.to_s
puts "sleep records created: " + Sleep.count.to_s
puts "test users will be user_id: 1 (high following) and user_id: 2 (high follower)"
puts "done seeding database"
