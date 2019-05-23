require 'sinatra'
require_relative 'base'

class UserFoodsController < Base
  get '/food_upload' do
    unless @current_user
      flash[:error] = "食材登録はログインしているユーザのみ使用可能です。"
      redirect '/auth/login' and return
    end
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

  get '/food_discard' do
    unless @current_user
      flash[:error] = "廃棄食材登録はログインしているユーザのみ使用可能です。"
      redirect '/auth/login' and return
    end
    erb :'user_foods/food_discard'
  end

  post '/food_discard' do
    #送られてきた廃棄食材が冷蔵庫に存在するか確認
    params[:items].each do |item|
      if exists_discarded_food_into_refrigerator?(item[:food_name])
        redirect '/user_foods/food_discard' and return
      end
    end
    DiscardedFood.transaction do
      params[:items].each do |item|
        discarded_food = DiscardedFood.new({
          name:       item[:food_name],
          gram:       item[:gram],
          user_id:    session[:user_id],
        })
        discarded_food.save!
      end
    end
      redirect '/'
    rescue ActiveRecord::RecordInvalid
      erb :'user_foods/food_discard'
  end

  private

  def exists_discarded_food_into_refrigerator?(food_name)
    #食材名が空文字列か冷蔵庫に食材が無い場合にエラー文を返す
    if food_name.blank?
      flash[:error] = "食材名入力は必須項目です。"
    elsif  !UserFood.exists?(:user_id => session[:user_id],:name => food_name)
      flash[:error] = "#{food_name}は冷蔵庫に登録されていません。"
    end
  end
end

