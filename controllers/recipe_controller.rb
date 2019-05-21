require 'sinatra'
require 'nokogiri'
require 'open-uri'
require_relative 'base'

class RecipesController < Base
  get '/' do
    erb :'recipes/genre_select'
  end

  post '/' do
    #ジャンル選択画面で選ばれた食材名・ジャンルをURL末尾に設定する
    food = UserFood.where(user_id: session[:user_id]).order(limit_date: :desc).limit(1)
    if params[:genre].blank?
      url = URI.encode "https://cookpad.com/search/#{food[0].name}"
    else
      url = URI.encode 'https://cookpad.com/search/'+ params[:genre] + '%E3%80%80' + food[0].name
    end

    charset = nil

    html = open(url) do |f|
	    charset = f.charset
	    f.read
    end
    @recipes = []
    doc = Nokogiri::HTML.parse(html, nil, charset)
    doc.xpath('//*[@id="main_content"]/div[5]/div[@class="recipe-preview"]').each do |node|
      #hash{:recipe_title => "hoge" , :recipe_link => "/hogeee" , :thumbnail => "https:~"}
      #↑この形式で配列に保存される
      hash =  {
        :recipe_title => node.xpath('.//div[@class="recipe-text"]/span[@class="title font16"]').text,
        :recipe_link => node.xpath('.//div[@class="recipe-text"]/span[@class="title font16"]/a').attribute("href").value,
        :thumbnail => node.xpath('.//div[@class="recipe-image wide"]/a/img').attribute("src").value,
      }
      @recipes.push(hash)
    end
    erb :'recipes/search_results'
  end

  get '/show' do
    recipe_path = params[:recipe_path]
    if recipe_path.blank?
      redirect '/recipe' and return
    end

    charset = nil
    # TODO: ネットワークエラーがおきたらどうする？
    html = open("https://cookpad.com#{recipe_path}") do |page|
      charset = page.charset
      page.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    @recipe_title = doc.xpath('//*[@id="recipe-title"]/h1').first.text
    @recipe_image = doc.xpath('//*[@id="main-photo"]/img').first.attribute("src").value

    # 材料一覧
    @ingredients = []
    doc.xpath('//*[@id="ingredients_list"]/div').each do |material_node|
      # 材料名ではなくカテゴリ名が表示されている場合に対応
      category = material_node.xpath('.//div[@class="ingredient_category"]')
      unless category.empty?
        @ingredients << category.text
        next
      end

      @ingredients << {
        name: material_node.xpath('.//div[@class="ingredient_name"]/span').text,
        amount: material_node.xpath('.//div[@class="ingredient_quantity amount"]').text,
      }
    end

    # TODO: 調理手順

    erb :'recipes/recipe_detail'
  end
end
