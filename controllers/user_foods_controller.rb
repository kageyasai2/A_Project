require 'sinatra'
require_relative 'base'

class UserFoodsController < Base
  before do
    if user_not_logged_in?
      redirect '/auth/login'
    end
  end

  get '/food_upload' do
    erb :'user_foods/food_upload'
  end

  post '/food_upload' do
    @foods = []
    erb :'user_foods/food_register'
  end

  post '/register' do
    UserFood.transaction do
      register_user_foods!(items: params[:items], user_id: session[:user_id])
    rescue ActiveRecord::RecordInvalid
      flash[:error] = '保存に失敗しました'
      return erb :'/user_foods/food_register'
    end

    redirect '/home'
  end

  def register_user_foods!(items:, user_id:)
    raise ActiveRecord::RecordInvalid if items.nil?

    is_err = false
    @user_foods =
      items.map do |item|
        user_food = UserFood.new({
          name: item[:food_name],
          limit_date: item[:date],
          user_id: user_id,
          gram: item[:gram],
          calorie: rand(100),
        })
        is_err = true unless user_food.save

        user_food
      end

    raise ActiveRecord::RecordInvalid if is_err
  end

  def user_not_logged_in?
    unless @current_user
      flash[:error] = '食材登録はログインしているユーザのみ使用可能です。'
    end
  end

end
