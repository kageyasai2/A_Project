require 'sinatra'
require 'sinatra/base'
require_relative 'config/environments'

Dir[CONTROLLERS_DIR + '/*.rb'].each do |controller|
  require controller
end

class Main < Sinatra::Base
  ROUTES = {
    '/' => Index,
  }
end
