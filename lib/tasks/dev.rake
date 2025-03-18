desc "Fill the database tables with some sample data"
task sample_data: :environment do

  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all
  end

  p "Creating sample data"

  # Create known user accounts for signing in

  usernames = Array.new { Faker::Name.first_name }
  usernames << "alice"
  usernames << "bob"

  usernames.each do |username|
    User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      private: [true, false].sample
    )
  end


  # Creating users

  12.times do
    name = Faker::Name.first_name
    u = User.create(
      email: "#{name}@example.com",
      password: "password",
      username: name,
      private: [true, false].sample
    )

    # p u.errors.full_messages
  end

  p "There are now #{User.count} users."


  # Creating follow request between each users

  users = User.all

  users.each do |first_user|
    users.each do |second_user|
      next  if first_user == second_user

      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.keys.sample
        )
      end

      if rand < 0.75
        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.keys.sample
        )
      end
    end
  end

  p "There are now #{FollowRequest.count} follow requests."

  # Creating photos, likes, and comments
  users.each do |user|
    rand(15).times do
      photo = user.own_photos.create(
        caption: Faker::Quotes::Shakespeare.hamlet_quote,
        image: "https://robohash.org/#{rand(9999)}?set=set4"
      )

      user.followers.each do |follower|
        if rand < 0.5 && !photo.fans.include?(follower)
          photo.fans << follower 
        end

        if rand < 0.25
          photo.comments.create(
            body: Faker::Quotes::Shakespeare.king_richard_iii_quote,
            author: follower
          )
        end
      end
    end
  end

  p "There are now #{Photo.count} photos."
  p "There are now #{Like.count} likes."
  p "There are now #{Comment.count} comments."
end
