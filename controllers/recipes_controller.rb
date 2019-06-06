require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'addressable/uri'
require_relative 'base'

class RecipesController < Base
  get '/' do
    erb :'recipes/genre_select'
  end

  post '/' do
    if exists_food_for_current_user?
      redirect '/recipes' and return
    end
    url = create_url

    doc =
      begin
      fetch_html_from(url)
      rescue OpenURI::HTTPError
        # TODO: エラーメッセージを動的に設定できる404ページを作成する
        return [404, ['指定したレシピが見つかりませんでした。', '再度検索をお願いいたします。']]
    end
    @recipes = parse_recipe_list(doc)
    erb :'recipes/search_results'
  end

  get '/show' do
    recipe_path = params[:recipe_path]
    if recipe_path.blank?
      redirect '/recipes' and return
    end

    doc =
      begin
      fetch_html_from Addressable::URI.encode("https://cookpad.com#{recipe_path}")
      rescue OpenURI::HTTPError
        # TODO: エラーメッセージを動的に設定できる404ページを作成する
        return [404, ['検索結果が見つかりませんでした。', '再度検索をお願いいたします。']]
    end

    @recipe_title = parse_recipe_title_from(doc)
    @recipe_image = parse_recipe_image_from(doc)

    # 材料一覧
    @ingredients = parse_recipe_ingredients_from(doc)
    # 調理手順
    @steps = parse_recipe_steps_from(doc)

    #冷蔵庫の食材一覧
    @refrigerator_foods = UserFood.fetch_foods_into_refrigerator(session[:user_id])
    erb :'recipes/recipe_detail'
  end

  post '/delete' do
    if params[:items].nil?
      redirect '/home'
    end

    UserFood.transaction do
      truncate_food_based_on(session[:user_id], params[:items])
    rescue ActiveRecord::RecordInvalid
      flash[:error] = '保存に失敗しました'
      return erb :index
    end

    redirect '/home'
  end

  private

  def fetch_html_from(url)
    OpenURI.open_uri(url) do |page|
      Nokogiri::HTML.parse(page.read, nil, page.charset)
    end
  end

  def parse_recipe_title_from(doc)
    doc.xpath('//*[@id="recipe-title"]/h1').first.text
  end

  def parse_recipe_image_from(doc)
    doc.xpath('//*[@id="main-photo"]/img').first.attribute('src').value
  end

  def parse_recipe_ingredients_from(doc)
    doc.xpath('//*[@id="ingredients_list"]/div').map do |ingredient_node|
      # 材料名ではなくカテゴリ名が表示されている場合に対応
      category = ingredient_node.xpath('.//div[@class="ingredient_category"]')
      unless category.empty?
        next category.text
      end

      {
        name: ingredient_node.xpath('.//div[@class="ingredient_name"]/span').text,
        amount: ingredient_node.xpath('.//div[@class="ingredient_quantity amount"]').text,
      }
    end
  end

  def parse_recipe_steps_from(doc)
    doc.xpath('//*[@id="steps"]/div[contains(@class, "step")]/dl/dd').map do |step_node|
      step = { text: step_node.xpath('.//p').text }

      # 調理手順の画像はある場合とない場合が混在するためチェック
      img_node = step_node.xpath('.//div/div/img')
      unless img_node.empty?
        step[:photo_src] = img_node.attribute('src').value
      end

      step
    end
  end

  def parse_recipe_list(doc)
    doc.xpath('//*[@id="main_content"]/div[5]/div[@class="recipe-preview"]').map do |node|
      # hash { recipe_title: "hoge", recipe_link: "/hogeee", thumbnail: "https:~" }
      # ↑この形式で配列に保存される
      {
        recipe_title: node.xpath('.//div[@class="recipe-text"]/span[@class="title font16"]').text,
        recipe_link: node.xpath('.//div[@class="recipe-text"]/span[@class="title font16"]/a').attribute('href').value,
        thumbnail: node.xpath('.//div[@class="recipe-image wide"]/a/img').attribute('src').value,
      }
    end
  end

  def exists_food_for_current_user?
    # レシピ機能はログインしているユーザのみ使用可能
    if !@current_user
      flash[:error] = 'レシピ検索機能はログインしているユーザのみ使用可能です。'
    elsif !UserFood.exists?(user_id: session[:user_id])
      flash[:error] = '冷蔵庫に食材がありません。 食材登録をしてください'
    end
  end

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
    end
  end

end
