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

    days_calorie_hash = DiscardedFood.
      where_my(session[:user_id]).
      where_current_month.
      group_by_date.
      sum_calorie
    @days_calorie_array = days_calorie_hash.each_key.map do |key|
      val = days_calorie_hash[key]
      [key.to_i, val]
    end

    months_calorie_hash = DiscardedFood.
      where_my(session[:user_id]).
      where_current_year.
      group_by_month.
      sum_calorie
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
