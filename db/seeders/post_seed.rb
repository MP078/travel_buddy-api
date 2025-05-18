# frozen_string_literal: true

require "faker"
require_relative "../../lib/image_downloader"

users = User.all.to_a
destinations = Destination.all.to_a

puts "Seeding posts, likes, and comments..."
40.times do |i|
  user = users.sample
  destination = destinations.sample

  start_date = Faker::Date.backward(days: rand(10..100))
  end_date = start_date + rand(1..7).days

  post = Post.create!(
    user: user,
    content: Faker::Lorem.paragraph(sentence_count: 2),
    destination: destination.name,
    start_date: start_date,
    end_date: end_date
  )

  rand(1..3).times do
    img_url = Faker::LoremFlickr.image(size: "400x300", search_terms: ["travel", "adventure"]).gsub("https://", "http://")
    ImageDownloader.attach_image_from_url(post, img_url, :images)
  end

  users.sample(rand(2..6)).each do |liker|
    Like.create!(user: liker, likeable: post)
  end

  rand(2..5).times do
    commenter = users.sample
    comment = Comment.create!(
      user: commenter,
      commentable: post,
      body: Faker::Lorem.sentence(word_count: 10)
    )
    users.sample(rand(0..3)).each do |liker|
      Like.create!(user: liker, likeable: comment)
    end
  end
  puts "Created post #{i + 1} by #{user.name}"
end
puts "Finished seeding posts, likes, and comments."
