require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'addressable/uri'
require_relative 'base'
require_relative '../services/cookpad_list_scraper'
require_relative '../services/cookpad_detail_scraper'
require_relative '../services/fetch_doc_service'

class RecipesController < Base
  before do
    if user_not_logged_in?
      redirect '/auth/login'
    end
  end

  get '/' do
    erb :'recipes/genre_select'
  end

  post '/' do
    if exists_food_for_current_user?
      redirect '/recipes'
    end

    url = create_url

    @recipes =
      begin
      CookpadListScraper.new(url).execute
      rescue OpenURI::HTTPError
        # TODO: エラーメッセージを動的に設定できる404ページを作成する
        return [404, ['指定したレシピが見つかりませんでした。', '再度検索をお願いいたします。']]
    end
    erb :'recipes/search_results'
  end

  get '/show' do
    recipe_path = params[:recipe_path]
    if recipe_path.blank?
      redirect '/recipes' and return
    end

    url = Addressable::URI.encode("https://cookpad.com#{recipe_path}")
    recipe_info =
      begin
      CookpadDetailScraper.new(url).execute
      rescue OpenURI::HTTPError
        # TODO: エラーメッセージを動的に設定できる404ページを作成する
        return [404, ['検索結果が見つかりませんでした。', '再度検索をお願いいたします。']]
    end

    @recipe_title = recipe_info[:recipe_title]
    @recipe_image = recipe_info[:recipe_image]

    # 材料一覧
    @ingredients = recipe_info[:ingredients]
    # 調理手順
    @steps = recipe_info[:steps]

    # 冷蔵庫の食材一覧
    @refrigerator_foods = UserFood.fetch_foods_into_refrigerator(session[:user_id])
    erb :'recipes/recipe_detail'
  end

  post '/delete' do
    if params[:items].nil?
      redirect '/home'
    end

    UserFood.transaction(joinable: false, requires_new: true) do
      truncate_food_based_on(session[:user_id], params[:items])
    rescue ActiveRecord::RecordInvalid
      flash[:error] = '保存に失敗しました'
      raise ActiveRecord::Rollback
    end

    redirect '/home'
  end

  private

  def create_url
    # ジャンル選択画面で選ばれた食材名・ジャンルをURL末尾に設定する
    food = UserFood.where(user_id: session[:user_id]).order(limit_date: :asc).limit(1)
    if params[:genre].blank?
      Addressable::URI.encode "https://cookpad.com/search/#{food[0].name}"
    else
      Addressable::URI.encode "https://cookpad.com/search/#{params[:genre]} #{food[0].name}"
    end
  end

  def truncate_food_based_on(user_id, items)
    items.each do |item|
      # 料理に使用した食材の廃棄
      used_food = UserFood.find_from(user_id, item[:food_name])

      if used_food.nil?
        next
      end

      # 料理に使用した食材を冷蔵庫から削除する
      used_food.update_gram_in_user_foods!(item[:gram])
      raise ActiveRecord::RecordInvalid
    end
  end

  def user_not_logged_in?
    unless @current_user
      flash[:error] = 'レシピ検索機能はログインしているユーザのみ使用可能です。'
    end
  end

  def exists_food_for_current_user?
    unless UserFood.exists?(user_id: session[:user_id])
      flash[:error] = '冷蔵庫に食材がありません。 食材登録をしてください'
    end
  end
end
