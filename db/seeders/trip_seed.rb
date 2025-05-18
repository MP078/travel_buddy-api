# frozen_string_literal: true

require "faker"
require_relative "../../lib/image_downloader"

difficulties = %w[easy medium hard]

users = User.all.to_a
destinations = Destination.all.to_a

# List of unique, high-quality image URLs
trip_images = [
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
]


puts "Seeding trips and trip participations..."
used_images = trip_images.shuffle

15.times do |i|
  destination = destinations.sample
  organizer = users.sample
  start_date = Faker::Date.forward(days: rand(5..30))
  end_date = start_date + rand(2..10).days

  trip = Trip.create!(
    title: "#{Faker::Lorem.words(number: 3).join(' ').titleize} Trip",
    location: destination.location,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    start_date: start_date,
    end_date: end_date,
    difficulty: difficulties.sample,
    cost: "Rs. #{rand(500..5000)}",
    maximum_participants: rand(3..10),
    activities: Array.new(rand(2..5)) { Faker::Hobby.activity },
    highlights: Array.new(rand(2..4)) { Faker::Lorem.words(number: 2).join(" ") }
  )

  # Attach a unique cover image
  cover_url = used_images.pop || trip_images.sample
  ImageDownloader.attach_image_from_url(trip, cover_url, :cover_image)

  # Attach 2 unique images for the trip
  2.times do
    img_url = used_images.pop || trip_images.sample
    ImageDownloader.attach_image_from_url(trip, img_url, :images)
  end

  # Create organizer participation (approved and organizer)
  TripParticipation.create!(
    user: organizer,
    trip: trip,
    approved: true,
    organizer: true,
    joined_at: start_date - rand(1..3).days
  )

  # Add random participants (excluding organizer, no duplicates)
  participant_pool = users - [organizer]
  num_participants = [participant_pool.size, trip.maximum_participants - 1].min
  participants = participant_pool.sample(rand(1..num_participants))

  participants.each do |participant|
    TripParticipation.create!(
      user: participant,
      trip: trip,
      approved: [true, false].sample,
      organizer: false,
      joined_at: start_date - rand(1..3).days
    )
  end

  puts "Created trip #{i + 1}: #{trip.title}"
end
puts "Finished seeding trips and participations."
