require 'sinatra'
require_relative 'base'

class UserFoodsController < Base
  get '/register' do
    erb :'user_foods/food_register'
  end

  post '/register' do
    UserFood.transaction do
      params[:item].each do |index|
        user_food = UserFood.new({
          name:       index[1][:food_name],
          limit_date: index[1][:date],
          user_id:    session[:user_id],
          gram:       index[1][:gram],
        })
        user_food.save!
      end
    end
    redirect '/'
    rescue => e
    redirect '/user_foods/register'
  end
end

