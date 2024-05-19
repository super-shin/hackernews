require "faker"

Post.destroy_all
User.destroy_all

user = User.new(username: 'moderator', email: 'moderator@yahoo.com', password_hash: 'secret')
user.save
100.times do
  post = Post.new(
    title: Faker::Hacker.say_something_smart,
    url: Faker::Internet.url,
    votes: (0..1000).to_a.sample
  )
  post.user = user
  post.save!
end
