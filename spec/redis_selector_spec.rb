$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))
require 'redis_selector'

class RedisUser
  extend RedisSelector

  def self.use_redis(what)
    with_redis(what) {|r| true}
  end
end

describe "RedisSelector" do
  it "works without being configured" do
    Redis.should_receive(:new).with(:host => 'localhost')
    RedisUser.use_redis(:something)
  end
end

describe "RedisSelector" do
  before do
    RedisSelector.configure(
      :leaderboards => {
        :host    => 'redisbox',
        :timeout => 30,
        :color   => 'blue',
      },
      :stringkeys => {
        'host' => 'localhost',
        'db'   => 1,
      })
  end

  it "passes along arbitrary options" do
    Redis.should_receive(:new).with(
      :host    => 'redisbox',
      :timeout => 30,
      :color   => 'blue')
    RedisUser.use_redis(:leaderboards)
  end

  it "converts keys to symbols" do
    Redis.should_receive(:new).with(
      :host => 'localhost',
      :db   => 1)
    RedisUser.use_redis(:stringkeys)
  end
end
