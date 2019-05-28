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

    # @discarded_foodsが空でないならDBに廃棄食材を保存する。
    DiscardedFood.transaction do
      discarded_foods.each do |item|
        gram = item[:gram]

        # 廃棄食材の登録
        discarded_food = DiscardedFood.new({
          name: item[:food_name],
          gram: gram,
          user_id: session[:user_id],
        })
        discarded_food.save!

        food = UserFood.find_from(session[:user_id], item[:food_name])

        if food.nil?
          next
        end

        food.update_gram_in_user_foods!(gram)
      end
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
    # 廃棄失敗食材リスト
    failure_discarded_foods = []
    # 廃棄成功食材リスト
    discarded_foods = []

    params[:items].each do |item|
      if item[:food_name].blank?
        next
      end

      # 冷蔵庫にitem[:food_name]が存在しないならTrue
      if !UserFood.exists?(user_id: session[:user_id], name: item[:food_name])
        failure_discarded_foods << item
      else
        discarded_foods << item
      end
    end

    return discarded_foods, failure_discarded_foods
  end
end
