require 'sinatra'
require_relative 'base'

require './models/userfood.rb'

class FoodController < Base
  get '/registor' do
    erb :'food/food_register'
  end

  post '/registor' do
    redirect '/'
  end
end