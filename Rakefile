require 'rspec/core/rake_task'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

desc "run spec"
task :default => [:spec]

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/*/*_spec.rb'
  spec.rspec_opts = %w(--color --format progress)
end
