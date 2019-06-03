require 'sinatra'
require_relative 'base'

class UserFoodsController < Base
  get '/food_upload' do
    unless @current_user
      flash[:error] = '食材登録はログインしているユーザのみ使用可能です。'
      redirect '/auth/login' and return
    end
    erb :'user_foods/food_upload'
  end

  post '/food_upload' do
    @foods = []
    erb :'user_foods/food_register'
  end

  post '/register' do
    foods = generate_foods

    UserFood.transaction do
      truncate_food_based_on(session[:user_id],foods)
    rescue ActiveRecord::RecordInvalid
      flash[:error] = '保存に失敗しました'
      return erb :'/user_foods/food_register'
    end
    
    flash.now[:foods] = foods
    return erb :'user_foods/food_register'
  end

  private

  def generate_foods
    foods = []
    params[:items].each do |item|
      if item[:food_name].blank?
        next
      end
      foods << item
    end
  end

  def truncate_food_based_on(user_id,foods)
    foods.each do |item|
      user_food = UserFood.new({
        name: item[:food_name],
        limit_date: item[:date],
        user_id: session[:user_id],
        gram: item[:gram],
        calorie: rand(100),
      })
      user_food.save!
    end
  end

end
