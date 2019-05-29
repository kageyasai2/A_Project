require 'sinatra'
require_relative 'base'

class IndexController < Base
  get '/' do
    erb :index
  end

  get '/home' do
    if session[:user_id]
      @user_foods = UserFood.where(user_id: session[:user_id]).order(limit_date: :asc)
    end
    @user_foods ||= []

    days_calorie_hash = DiscardedFood.read_daily_calories_by(session[:user_id])
    @days_calorie_array = days_calorie_hash.each_key.map do |key|
      val = days_calorie_hash[key]
      [key.to_i, val]
    end

    months_calorie_hash = DiscardedFood.read_monthly_calories_by(session[:user_id])
    @months_calorie_array = months_calorie_hash.each_key.map do |key|
      val = months_calorie_hash[key]
      [key.to_i, val]
    end

    erb :home
  end

  get '/terms_of_service' do
    erb :terms_of_service
  end

  get '/unsubscribed' do
    erb :unsubscribed
  end
end
