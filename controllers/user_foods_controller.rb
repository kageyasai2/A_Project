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
    #廃棄に成功した食材と廃棄に失敗した食材を取得
    discarded_food_list , failure_discarded_food_list =  exists_discarded_food_into_refrigerator
    #廃棄成功食材がある場合のみ処理実行
    if setting_error_message?(discarded_food_list,failure_discarded_food_list)
      redirect '/user_foods/food_discard' and return
    end

    DiscardedFood.transaction do
      discarded_food_list.each do |item|
        discarded_food = DiscardedFood.new({
          name:       item[:food_name],
          gram:       item[:gram],
          user_id:    session[:user_id],
        })
        discarded_food.save!
      end
    end
      #廃棄成功食材をflash[:discarded_food]に入れる
      flash[:discarded_food] = discarded_food_list
      redirect 'user_foods/food_discard'
    rescue ActiveRecord::RecordInvalid
      erb :'user_foods/food_discard'
  end

  private

  #廃棄成功食材と廃棄失敗食材のリストを返す
  def exists_discarded_food_into_refrigerator
    #廃棄失敗食材リスト
    failure_discarded_food_list = []
    #廃棄成功食材リスト
    discarded_food_list = []
    params[:items].each do |item|
      #item[:food_name]が空文字列でない
      if !item[:food_name].blank?
        #冷蔵庫にitem[:food_name]が存在しないならTrue
        if !UserFood.exists?(user_id: session[:user_id],name: item[:food_name])
          failure_discarded_food_list.push(item[:food_name])
        else 
          discarded_food_list.push(item)
        end
      end
    end
    
    return discarded_food_list,failure_discarded_food_list
  end
  #エラーメッセージを設定する
  def setting_error_message?(discarded_food_list,failure_discarded_food_list)
    if discarded_food_list.empty? && failure_discarded_food_list.empty?
      flash[:error] = "食材名は必須項目です。"
    elsif discarded_food_list.empty? && failure_discarded_food_list.present?
      flash[:failure_discarded_food] = failure_discarded_food_list
    elsif discarded_food_list.present? && failure_discarded_food_list.present?
      flash[:failure_discarded_food] = failure_discarded_food_list
      false
    end
  end
end

