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
    #送られてきた廃棄食材が冷蔵庫に存在するかの確認
    if exists_discarded_food_into_refrigerator?
      redirect '/user_foods/food_discard' and return
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
      flash[:error] = "食材名は入力必須項目です。"
      erb :'user_foods/food_discard'
  end

  private

  #冷蔵庫に廃棄したい食材が無ければTrueを返す
  def exists_discarded_food_into_refrigerator?
    discarded_food_list = []
    params[:items].each do |item|
      #item[:food_name]が空文字列でない　かつ　冷蔵庫にitem[:food_name]が存在しない
      if !item[:food_name].blank? && !UserFood.exists?(user_id: session[:user_id],name: item[:food_name])
        discarded_food_list.push(item[:food_name])
      end
    end

    unless discarded_food_list.empty?
      #冷蔵庫にない廃棄食材をflash[:discarded_food]に格納
      flash[:discarded_food] = discarded_food_list
    end
  end
end

