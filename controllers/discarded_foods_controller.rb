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
    register_discarded_food(items: params[:items], user_id: session[:user_id])
    return erb :'discarded_foods/food_discard'
  end

  private

  def user_not_logged_in?
    unless @current_user
      flash[:error] = '廃棄食材登録はログインしているユーザのみ使用可能です。'
    end
  end

  def register_discarded_food(items:, user_id:)
    flash[:discarded_foods] = []
    flash[:failure_discarded_foods] = []

    items.each do |item|
      DiscardedFood.transaction(joinable: false, requires_new: true) do
        discarded_food = DiscardedFood.new({
          name: item[:food_name],
          gram: item[:gram],
          calorie: rand(100),
          user_id: user_id,
        })

        food = UserFood.find_from(user_id, item[:food_name])
        if discarded_food.save && food
          # 廃棄登録された食材を冷蔵庫から削除する
          p "debug message2 "
          food.update_gram_in_user_foods!(item[:gram])
          flash[:discarded_foods] << discarded_food
        else

          if item[:food_name].present? && food.nil?
            discarded_food.errors[:name] << 'は冷蔵庫から見つかりません。'
          end

          flash[:failure_discarded_foods] << discarded_food
        end
      rescue ActiveRecord::RecordInvalid
        p "debug_message"
        raise ActiveRecord::Rollback
      end
    end
  end
end
