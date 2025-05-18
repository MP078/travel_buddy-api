users = User.all.to_a

puts "Seeding friendships..."
users.each_with_index do |user, i|
  potential_friends = users.reject { |u| u == user }
  potential_friends.sample(3).each do |friend|
    unless Friendship.between(user, friend).exists?
      Friendship.create!(
        requester: user,
        receiver: friend,
        status: %w[pending accepted].sample
      )
    end
  end
  puts "Processed friendships for user #{i + 1}/#{users.size}: #{user.name}"
end
puts "Finished seeding friendships."
