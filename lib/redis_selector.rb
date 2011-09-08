require "redis_selector/version"

module RedisSelector
  DEFAULT_REDIS = {
    'host' => 'localhost',
  }.freeze

  class << self
    attr_accessor :mocking
    attr_accessor :mock_redises
    attr_accessor :config
  end
  self.mock_redises ||= {}

  def self.mock!
    require 'mock_redis'
    self.mocking = true
  end

  def self.unmock!
    self.mocking = false
  end

  def self.configure(config)
    self.config = config
  end

  # Rather than have one big global Redis, we let you get a Redis for
  # a specific purpose. That way, if thing X's data set gets too
  # large, you can point Redis.for(X) at a different redis-server
  # instance, thus allowing for sharding based on logical data
  # grouping.
  #
  # This doesn't address the problem of data migration.
  def with_redis(what)
    redis_selector = Module.nesting[0]

    config = redis_selector.config || {}
    redis_info = config[what] || config['default'] || DEFAULT_REDIS

    redis = if redis_selector.mocking
              # A MockRedis instance doesn't persist anywhere once we
              # drop a reference to it, while a real Redis
              # does. That's why we hold onto this mock like this;
              # otherwise, repeated calls to with_redis(:foo) each get
              # a completely empty mock.
              redis_selector.mock_redises[redis_info['host']] ||= MockRedis.new
            else
              Redis.new(:host => redis_info['host'])
            end

    redis.select(redis_info['db']) if redis_info['db']
    result = yield redis
    result
  ensure
    redis.quit if redis
  end
end
