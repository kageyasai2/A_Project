require 'sinatra'
require_relative 'base'

require './models/userfood.rb'

class FoodController < Base
  get '/register' do
    erb :'food/food_register'
  end

  post '/register' do
    #入力チェック
    params[:item].each do |index|
      if index[1][:food_name].blank?
        redirect '/food/register'
      end
    end

    params[:item].each do |index|
      #今の所user_idは1に固定する
      #ログイン機能ができればuser_idにsession[:user_id]を入れる
      userfood = Userfood.new({
        name:       index[1][:food_name],
        limit_date: index[1][:date],
        user_id:    1,
        gram:       index[1][:gram],
      })
      unless userfood.save
        erb :'food/food_register'
      end
    end
    redirect '/'
  end
end

