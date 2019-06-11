require 'sinatra'
require_relative 'base'

class IndexController < Base
  get '/' do
    if @current_user
      redirect 'home'
    else
      erb :index
    end
  end

  get '/home' do
    if session[:user_id]
      @user_foods = UserFood.where(user_id: session[:user_id]).order(limit_date: :asc)
    end
    @user_foods ||= []

    monthly_calories_hash = DiscardedFood.read_monthly_calories_by(session[:user_id])
    gon.monthly_kill_retios = generate_loss_degrees_by(
      calories_hash: monthly_calories_hash,
      day_or_month: :month,
    )
    gon.monthly_contributes = generate_contribute_degrees_by(
      calories_hash: monthly_calories_hash,
      day_or_month: :month,
    )

    daily_calories_hash = DiscardedFood.read_daily_calories_by(session[:user_id])
    gon.daily_kill_retios = generate_loss_degrees_by(
      calories_hash: daily_calories_hash,
      day_or_month: :day,
    )
    gon.daily_contributes = generate_contribute_degrees_by(
      calories_hash: daily_calories_hash,
      day_or_month: :day,
    )

    begin
      fetch_random_recipe
    rescue => e
      warn 'This error is known.'
      warn e.backtrace
    end

    erb :home
  end

  def generate_loss_degrees_by(calories_hash:, day_or_month:)
    kill_retios =
      calories_hash.map do |key, cal|
        [key, LossHelper.calc_kill_retio(discarded_calorie: cal, day_or_month: day_or_month)]
      end
    kill_retios_hash = kill_retios.to_h

    filled_kill_retios_hash =
      case day_or_month
      when :month then
        DateHelper.fill_calorie_of_monthly_as_zero(kill_retios_hash)
      when :day then
        DateHelper.fill_calorie_of_daily_as_zero(Time.current.month, kill_retios_hash)
      else
        raise AugumentError, 'day_or_month引数には:dayか:monthのどちらかを指定してください'
      end
    DateHelper.convert_to_nums_array(filled_kill_retios_hash).sort { |a, b| a[0] <=> b[0] }
  end

  def generate_contribute_degrees_by(calories_hash:, day_or_month:)
    contributes =
      calories_hash.map do |key, cal|
        [key, ContributionHelper.calc_contribute_num(discarded_calorie: cal, day_or_month: day_or_month)]
      end
    contributes_hash = contributes.to_h

    filled_contributes_hash =
      case day_or_month
      when :month then
        DateHelper.fill_calorie_of_monthly_as_zero(contributes_hash)
      when :day then
        DateHelper.fill_calorie_of_daily_as_zero(Time.current.month, contributes_hash)
      else
        raise AugumentError, 'day_or_month引数には:dayか:monthのどちらかを指定してください'
      end
    DateHelper.convert_to_nums_array(filled_contributes_hash).sort { |a, b| a[0] <=> b[0] }
  end

  get '/terms_of_service' do
    erb :terms_of_service
  end

  get '/unsubscribed' do
    erb :unsubscribed
  end

  private

  def fetch_random_recipe
    food = UserFood.where(user_id: session[:user_id]).order(limit_date: :asc).limit(1)
    return if food.blank?

    url = Addressable::URI.encode "https://cookpad.com/search/#{food[0].name}"
    recipes = CookpadListScraper.new(url).execute

    return if recipes.blank?

    recipe_path = recipes[rand(recipes.size)][:recipe_link]
    url = Addressable::URI.encode("https://cookpad.com#{recipe_path}")
    @recommend_recipe = CookpadDetailScraper.new(url).execute
  end
end
