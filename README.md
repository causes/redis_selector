# MockRedis

A gem to make it easy to use different Redises for different things.

## Getting Started

RedisSelector is a module that provides the `#with_redis` method.

`#with_redis` takes a string and a block, and calls the block with a
connected Redis object. The connection is closed after the block
exits.

The string is used to indicate what logical thing you're using Redis
for. This allows for easy addition of new Redis servers if your data
set starts getting too big.

Example:

    class Competitor < ActiveRecord::Base
      extend MockRedis

      def self.top10
        with_redis('leaderboards') do |redis|
          redis.zrange(LEADERBOARD_KEY, 0, 9).map {|id| self.find(id)}
        end
      end
    end

    class BlogPostsController < ApplicationController

      def create
        # ...
        with_redis('blog_posts') {|r| r.incr('blog_posts_created' }
        render
      end
    end


By default, both these calls will connect to the same Redis. Now,
let's say your leaderboard data is getting really big, and it's taking
up too much space on your one little Redis machine. You spin up a new
one and tell `RedisSelector` about it:

    RedisSelector.configure(
      'leaderboards' => {'host' => 'big-huge-redis-box'}
      # default is localhost for things not mentioned here
    )
     
Then, Marketing goes crazy and starts posting blogs all over the
place, and all your blog posts start taking up a ton of space.

    RedisSelector.configure(
      'leaderboards' => {'host' => 'big-huge-redis-box'}
      'blog_posts'   => {'host' => 'other-redis-box'}
      # default is localhost for things not mentioned here
    )

That's the only code change you have to make. Throw that in
`config/environments/production.rb` and you're done. In development,
you probably haven't bothered to set anything up, so everything will
just go to localhost.

You can get separation by using different Redis databases, too. For
example, if two different models use the same Redis keys and step on
each other, you can split them up like so:

    RedisSelector.configure(
      'model1' => {'host' => 'redis-box', 'db' => 1}
      'model2' => {'host' => 'redis-box', 'db' => 2}
      # default is localhost/0 for things not mentioned here
    )

Since they're in different databases, they get their own keyspaces and
don't step on each other.

## Testing

`RedisSelector` supports the use of `MockRedis` in test mode. Add
`mock_redis` to your `Gemfile`, and call `RedisSelector.mock!`.
