def self.start
    self.user_data
    self.tweet_data
end

def self.user_data
    5.times do
        screen_name = Faker::Twitter.user[:screen_name]

        fake_data = {
            username: screen_name,
            email: "#{ screen_name }@flatiron-school.com",
            password: 'password'
        }

        User.create(fake_data)
    end
end

def self.tweet_data
    20.times do
        tweet = Tweet.new(content: Faker::ChuckNorris.fact)
        tweet.user_id = User.all.sample[:id]
        tweet.save
    end
end

self.start