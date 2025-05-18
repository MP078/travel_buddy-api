# frozen_string_literal: true

require "faker"
require_relative "../../lib/image_downloader"

users = User.all.to_a

puts "Seeding stories..."
users.each_with_index do |user, i|
  rand(1..3).times do |j|
    story = Story.new(
      user: user,
      caption: Faker::Lorem.sentence(word_count: 6),
      location: Faker::Address.city
    )
    image_url = Faker::LoremFlickr.image(size: "400x700", search_terms: ["travel", "adventure"]).gsub("https://", "http://")
    ImageDownloader.attach_image_from_url(story, image_url, :image)
    story.save! # Now validation will pass
    puts "Created story #{j + 1} for user #{user.name}"
  end
  puts "Processed stories for user #{i + 1}/#{users.size}: #{user.name}"
end
puts "Finished seeding stories."
