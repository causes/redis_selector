# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redis_selector/version"

Gem::Specification.new do |s|
  s.name        = "redis_selector"
  s.version     = RedisSelector::VERSION
  s.authors     = ["Samuel Merritt"]
  s.email       = ["spam@andcheese.org"]
  s.homepage    = ""
  s.summary     = %q{Easy way to select different Redis instances/databases based on purpose.}
  s.description = %q{Lets you select different Redis instances/databases easily.
    This way, you get logical grouping of different Redis datasets.

    Also supports mocking in test mode (via mock_redis gem).
  }

  s.rubyforge_project = "redis_selector"

  s.add_dependency  "redis"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
