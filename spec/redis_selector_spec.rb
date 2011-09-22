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
