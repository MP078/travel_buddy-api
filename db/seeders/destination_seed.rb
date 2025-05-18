require 'faker'
require 'date'
require_relative '../../lib/image_downloader'

difficulties = %w[easy medium hard]
months = Date::MONTHNAMES.compact

puts "Seeding destinations..."
50.times do |i|
  city = Faker::Address.city
  country = Faker::Address.country
  destination = Destination.create!(
    name: city,
    location: "#{city}, #{country}",
    description: Faker::Lorem.paragraph(sentence_count: 3),
    best_time_to_visit: "#{months.sample} - #{months.sample}",
    average_cost: "#{rand(200..2000)} USD",
    difficulty: difficulties.sample,
    activities: Array.new(rand(2..5)) { Faker::Hobby.activity },
    highlights: Array.new(rand(2..4)) { Faker::Lorem.words(number: 2).join(' ') },
    travel_tips: Array.new(rand(1..3)) { Faker::Lorem.sentence(word_count: 8) }
  )
  image_url = Faker::LoremFlickr.image(size: "400x300", search_terms: ['travel', 'destination']).gsub('https://', 'http://')
  ImageDownloader.attach_image_from_url(destination, image_url, :image)
  puts "Created destination #{i + 1}: #{destination.name}"
end
puts "Finished seeding destinations."
