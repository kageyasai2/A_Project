ENV['RACK_ENV'] = 'test'

require_relative '../config/environments'
require File.join(ROOT_DIR, 'main.rb')

require 'rspec'
require 'rack/test'

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

def app
  Sinatra::Application
end
