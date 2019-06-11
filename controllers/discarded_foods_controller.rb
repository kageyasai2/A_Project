require 'sinatra'
require_relative 'base'

class DiscardedFoodsController < Base
  before do
    if user_not_logged_in?
      redirect '/auth/login'
    end
  end

  get '/food_discard' do
    erb :'discarded_foods/food_discard'
  end

  post '/food_discard' do
    DiscardedFood.transaction do
      register_discarded_food!(items: params[:items], user_id: session[:user_id])
    rescue ActiveRecord::RecordInvalid
      flash[:error] = '保存に失敗しました'
    end

    return erb :'discarded_foods/food_discard'
  end

  private

  def user_not_logged_in?
    unless @current_user
      flash[:error] = '廃棄食材登録はログインしているユーザのみ使用可能です。'
    end
  end

  def register_discarded_food!(items:, user_id:)
    flash[:discarded_foods] = []
    flash[:failure_discarded_foods] = []
    is_err = false

    items.each do |item|
      discarded_food = DiscardedFood.new({
        name: item[:food_name],
        gram: item[:gram],
        calorie: rand(100),
        user_id: user_id,
      })

      food = UserFood.find_from(user_id, item[:food_name])
      if discarded_food.valid? && food
        # 廃棄登録された食材を冷蔵庫から削除する
        food.update_gram_in_user_foods!(item[:gram])
        flash[:discarded_foods] << discarded_food
      else
        is_err = true

        if item[:food_name].present? && food.nil?
          discarded_food.errors[:name] << 'not found in the refrigerator'
        end

        flash[:failure_discarded_foods] << discarded_food
      end
    end

    raise ActiveRecord::RecordInvalid if is_err
  end
end
