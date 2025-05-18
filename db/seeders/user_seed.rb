# frozen_string_literal: true

require "faker"
require_relative "../../lib/image_downloader"

puts "Seeding users..."
50.times do |i|
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password",
    bio: Faker::Lorem.sentence(word_count: 10),
    location: Faker::Address.city,
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    about: Faker::Lorem.paragraph(sentence_count: 3),
    certifications: Array.new(rand(0..3)) { Faker::Educator.degree },
    interests: Array.new(rand(1..4)) { Faker::Hobby.activity },
    languages: Array.new(rand(1..3)) { Faker::Nation.language },
    website: Faker::Internet.url,
  )
  avatar_url = Faker::Avatar.image.gsub("https://", "http://")
  ImageDownloader.attach_image_from_url(user, avatar_url, :avatar)
  puts "Created user #{i + 1}: #{user.name}"
end
puts "Finished seeding users."
