require 'sinatra'
require_relative 'base'

class DiscardedFoodsController < Base
  get '/food_discard' do
    unless @current_user
      flash[:error] = '廃棄食材登録はログインしているユーザのみ使用可能です。'
      redirect '/auth/login' and return
    end
    erb :'discarded_foods/food_discard'
  end

  post '/food_discard' do
    # 廃棄に成功した食材と廃棄に失敗した食材を取得
    discarded_foods, failure_discarded_foods = generate_discarded_foods

    if discarded_foods.blank?
      flash[:failure_discarded_foods] = failure_discarded_foods
      return erb :'discarded_foods/food_discard'
    end

    DiscardedFood.transaction do
      truncate_food_based_on(session[:user_id], discarded_foods)
    rescue ActiveRecord::RecordInvalid
      flash[:error] = '保存に失敗しました'
      return erb :'discarded_foods/food_discard'
    end

    flash[:discarded_foods] = discarded_foods
    flash[:failure_discarded_foods] = failure_discarded_foods
    return erb :'discarded_foods/food_discard'
  end

  private

  # 廃棄成功食材と廃棄失敗食材のリストを返す
  def generate_discarded_foods
    failure_discarded_foods = []
    discarded_foods = []

    params[:items].each do |item|
      if item[:food_name].blank?
        next
      end

      if UserFood.exists?(user_id: session[:user_id], name: item[:food_name])
        discarded_foods << item
      else
        failure_discarded_foods << item
      end
    end

    return discarded_foods, failure_discarded_foods
  end

  def truncate_food_based_on(user_id, discarded_foods)
    discarded_foods.each do |item|
      gram = item[:gram]

      # 廃棄食材の登録
      discarded_food = DiscardedFood.new({
        name: item[:food_name],
        gram: gram,
        calorie: rand(100),
        user_id: user_id,
      })
      discarded_food.save!

      food = UserFood.find_from(user_id, item[:food_name])

      if food.nil?
        next
      end

      # 廃棄登録された食材を冷蔵庫から削除する
      food.update_gram_in_user_foods!(gram)
    end
  end
end
