require 'faker'
require_relative '../../lib/image_downloader'

difficulties = %w[easy medium hard]

users = User.all.to_a
destinations = Destination.all.to_a

puts "Seeding trips and trip participations..."
30.times do |i|
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
    highlights: Array.new(rand(2..4)) { Faker::Lorem.words(number: 2).join(' ') }
  )

  cover_url = Faker::LoremFlickr.image(size: "600x400", search_terms: ['adventure', 'travel']).gsub('https://', 'http://')
  ImageDownloader.attach_image_from_url(trip, cover_url, :cover_image)
  2.times do
    img_url = Faker::LoremFlickr.image(size: "400x300", search_terms: ['nature', 'trip']).gsub('https://', 'http://')
    ImageDownloader.attach_image_from_url(trip, img_url, :images)
  end

  TripParticipation.create!(
    user: organizer,
    trip: trip,
    approved: true,
    organizer: true,
    joined_at: start_date - rand(1..3).days
  )

  (rand(1..trip.maximum_participants - 1)).times do
    participant = (users - [organizer]).sample
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
