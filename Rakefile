require 'bundler/gem_tasks'
require 'bundler/setup'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w(-fs --color)
  t.pattern = "spec/**/*_spec.rb"
end

task :default => :spec
