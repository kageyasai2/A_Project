require 'sinatra'
require_relative 'base'

class RefrigeratorController < Base
  before do
    if @current_user.blank?
      flash[:error] = '食材管理画面はログインしているユーザのみ使用可能です。'
      redirect '/auth/login'
    end
  end

  get '/' do
    @user_foods = UserFood.where_my(@current_user.id)
    erb :'refrigerator/index'
  end

  post '/' do
    UserFood.transaction(joinable: false, requires_new: true) do
      register_user_foods!(items: params[:items], user_id: session[:user_id])
    rescue ActiveRecord::RecordInvalid
      flash[:error] = '保存に失敗しました'
      return erb :'/refrigerator/index'
    end

    redirect '/refrigerator'
  end

  post '/update' do
    @user_foods = UserFood.where_my(@current_user.id)
    user_food_ids = @user_foods.pluck(:id)

    # ポストされたfood_idsに存在しないものを削除
    items = params[:items]
    user_food_ids.each do |id|
      items_index = items.index { |item| item[:id].to_i == id }
      unless items_index
        @user_foods.find(id).destroy
      end
    end

    # 存在するuser_foodsはポストされたデータで全て更新する
    items.each do |item|
      @user_foods.find(item[:id].to_i).update(
        name: item[:food_name],
        limit_date: item[:date],
        gram: item[:gram],
      )
    end

    erb :'/refrigerator/index'
  end

  private

  def register_user_foods!(items:, user_id:)
    raise ActiveRecord::RecordInvalid if items.nil?

    is_err = false
    @posted_foods =
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
end
