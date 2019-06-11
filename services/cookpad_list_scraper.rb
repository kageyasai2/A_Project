require_relative 'fetch_doc_service'
require_relative 'cookpad_list_parser'

class CookpadListScraper
  include CookpadListParser

  def initialize(url)
    @url = url
  end

  def execute
    @doc = FetchDocService.new(@url).execute

    parse_recipe_list
  end

  def parse_recipe_list
    parse_recipes(@doc).map do |node|
      # hash { recipe_title: "hoge", recipe_link: "/hogeee", thumbnail: "https:~" }
      # ↑この形式で配列に保存される
      {
        recipe_title: parse_recipe_title(node),
        recipe_link: parse_recipe_link(node),
        thumbnail: parse_recipe_thumbnail(node),
      }
    end
  end
end
