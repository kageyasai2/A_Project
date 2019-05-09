require 'sinatra'

require_relative 'main'
run Rack::URLMap.new(Main::ROUTES)
