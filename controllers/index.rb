require 'sinatra'
require_relative 'base'

class IndexController < Base
  get '/' do
    erb :index
  end
end
