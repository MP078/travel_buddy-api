# frozen_string_literal: true

require "faker"
require "securerandom"
require_relative "../../lib/image_downloader"

users = User.all.to_a

# Use a list of unique, high-quality image URLs
story_images = [
  "https://plus.unsplash.com/premium_photo-1668024966086-bd66ba04262f?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8c2NlbmVyeXxlbnwwfHwwfHx8MA%3D%3D",
  "https://media.istockphoto.com/id/517188688/photo/mountain-landscape.jpg?s=612x612&w=0&k=20&c=A63koPKaCyIwQWOTFBRWXj_PwCrR4cEoOw2S9Q7yVl8=",
  "https://st2.depositphotos.com/1591133/8812/i/450/depositphotos_88120646-stock-photo-idyllic-summer-landscape-with-clear.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2RgoNrHq5hpbqCfDLHT40jaHr65jZK9ciKA&s",
  "https://media.istockphoto.com/id/1381637603/photo/mountain-landscape.jpg?s=612x612&w=0&k=20&c=w64j3fW8C96CfYo3kbi386rs_sHH_6BGe8lAAAFS-y4=",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqTAFGBWEqQhdD46V-YzKCFuWq049w2uwwaA&s",
  "https://thumbs.dreamstime.com/b/beautiful-autumn-scenery-park-beautiful-autumn-scenery-park-outdoor-photography-sunrise-light-101482086.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6K8ceMQHkleTviazwC0ApqA73iW7MYUGqXg&s",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTk8FVn1_KKud1kkC-icIkdu_DkHhg4iqlASw&s",
  "https://hips.hearstapps.com/hmg-prod/images/sunset-over-varenna-lake-como-italy-royalty-free-image-1734456352.pjpeg?crop=1xw:0.99953xh;center,top&resize=980:*",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRthLDGWg4ehdCGBHHdAwlNTdhdHwuknL3kew&s"
].shuffle

puts "Seeding stories..."
image_index = 0
users.each_with_index do |user, i|
  rand(1..3).times do |j|
    story = Story.new(
      user: user,
      caption: Faker::Lorem.sentence(word_count: 6),
      location: Faker::Address.city
    )
    # Pick a unique image from the list, or reuse if more stories than images
    image_url = story_images[image_index % story_images.length]
    image_index += 1
    ImageDownloader.attach_image_from_url(story, image_url, :image)
    story.save!
    puts "Created story #{j + 1} for user #{user.name}"
  end
  puts "Processed stories for user #{i + 1}/#{users.size}: #{user.name}"
end
puts "Finished seeding stories."
