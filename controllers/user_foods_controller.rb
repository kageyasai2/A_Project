require 'sinatra'
require_relative 'base'

class UserFoodsController < Base
  get '/food_upload' do
    erb :'user_foods/food_upload'
  end

  post '/food_upload' do
    @foods = []
    erb :'user_foods/food_register'
  end

  post '/register' do
    UserFood.transaction do
      params[:items].each do |item|
        user_food = UserFood.new({
          name:       item[:food_name],
          limit_date: item[:date],
          user_id:    session[:user_id],
          gram:       item[:gram],
        })
        user_food.save!
      end
    end
      redirect '/'
    rescue ActiveRecord::RecordInvalid
      erb :'/user_foods/food_register'
  end
end

