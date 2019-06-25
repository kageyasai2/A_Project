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
