require 'sinatra'
require_relative 'base'

class UserFoodsController < Base
  get '/register' do
    erb :'userfoods/food_register'
  end

  post '/register' do
    #入力チェック
    params[:item].each do |index|
      if index[1][:food_name].blank?
        erb :'userfoods/food_register' and return
      end
    end

    params[:item].each do |index|
      user_food = User_Food.new({
        name:       index[1][:food_name],
        limit_date: index[1][:date],
        user_id:    session[:user_id],
        gram:       index[1][:gram],
      })
      unless user_food.save
        erb :'userfoods/food_register' and return
      end
    end
    redirect '/'
  end
end

