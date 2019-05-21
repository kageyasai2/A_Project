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
    url = URI.encode 'https://cookpad.com/search/'+params[:food]

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
end