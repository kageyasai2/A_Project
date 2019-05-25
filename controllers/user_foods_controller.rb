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
    # 廃棄に成功した食材と廃棄に失敗した食材を取得
    @discarded_food_list , @failure_discarded_food_list =  get_discarded_food_list

    if @discarded_food_list.blank?
      return erb :'user_foods/food_discard'
    end

    # @discarded_food_listが空でないならDBに廃棄食材を保存する。
    DiscardedFood.transaction do
      @discarded_food_list.each do |item|
        gram = item[:gram]

        # 廃棄食材の登録
        discarded_food = DiscardedFood.new({
          name:    item[:food_name],
          gram:    gram,
          user_id: session[:user_id],
        })
        discarded_food.save!

        food = UserFood.where(user_id: session[:user_id], name: item[:food_name]).limit(1)
        if food.blank?
          next
        end

        # UserFoodの消去、または減量
        food = food.first
        if gram.blank? || food.gram <= gram.to_i
          food.destroy
        else
          food.update!(gram: food.gram - gram.to_i)
        end
      end
    rescue ActiveRecord::RecordInvalid
      return erb :'user_foods/food_discard'
    end

    return erb :'user_foods/food_discard'
  end

  private

  #廃棄成功食材と廃棄失敗食材のリストを返す
  def get_discarded_food_list
    #廃棄失敗食材リスト
    failure_discarded_food_list = []
    #廃棄成功食材リスト
    discarded_food_list = []

    params[:items].each do |item|
      if item[:food_name].blank?
        next
      end

      #冷蔵庫にitem[:food_name]が存在しないならTrue
      if !UserFood.exists?(user_id: session[:user_id], name: item[:food_name])
        failure_discarded_food_list << item[:food_name]
      else
        discarded_food_list << item
      end
    end

    return discarded_food_list, failure_discarded_food_list
  end

end
