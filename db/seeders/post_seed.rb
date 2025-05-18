# frozen_string_literal: true

require "faker"
require_relative "../../lib/image_downloader"

users = User.all.to_a
destinations = Destination.all.to_a

# Use a list of unique, high-quality image URLs
post_images = [
  "https://pixabay.com/photos/mountain-lake-reflection-1z2niibpg5a/",
  "https://www.pexels.com/photo/road-between-trees-1546901/",
  "https://pixabay.com/photos/sunset-ocean-cliffs-sea-sky-1234567/",
  "https://unsplash.com/photos/2lowvivhz-e",
  "https://www.pexels.com/photo/green-grass-field-and-mountain-1231231/",
  "https://pixabay.com/photos/desert-dunes-sunrise-sand-2345678/",
  "https://unsplash.com/photos/6anudmpilw4",
  "https://www.pexels.com/photo/starry-sky-over-mountains-9876543/",
  "https://pixabay.com/photos/lake-dawn-reflection-water-3456789/",
  "https://unsplash.com/photos/1z2niibpg5a",
  "https://www.pexels.com/photo/green-farmland-4567890/",
  "https://pixabay.com/photos/rocky-coastline-waves-sea-5678901/",
  "https://unsplash.com/photos/6anudmpilw4",
  "https://www.pexels.com/photo/mountain-road-through-trees-6789012/",
  "https://pixabay.com/photos/frozen-lake-snowy-mountains-7890123/",
  "https://unsplash.com/photos/2lowvivhz-e",
  "https://www.pexels.com/photo/tropical-beach-palm-trees-8901234/",
  "https://pixabay.com/photos/autumn-leaves-water-9012345/",
  "https://unsplash.com/photos/3z3z1z1z1z1",
  "https://www.pexels.com/photo/forest-path-in-autumn-6789013/"
].shuffle

puts "Seeding posts, likes, and comments..."
image_index = 0
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

  # Attach 1-3 unique images to each post
  rand(1..3).times do
    image_url = post_images[image_index % post_images.length]
    image_index += 1
    ImageDownloader.attach_image_from_url(post, image_url, :images)
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
