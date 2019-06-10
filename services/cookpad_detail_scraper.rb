require_relative 'fetch_doc_service'
require_relative 'cookpad_detail_parser'

class CookpadDetailScraper
  include CookpadDetailParser

  def initialize(url)
    @url = url
  end

  def execute
    @doc = FetchDocService.new(@url).execute

    parse_recipe_detail
  end

  private

  def parse_recipe_detail
    recipe_title = parse_recipe_title(@doc)
    recipe_image = parse_recipe_image(@doc)

    # 材料一覧
    ingredients = parse_recipe_ingredients(@doc)
    # 調理手順
    steps = parse_recipe_steps(@doc)

    {
      recipe_title: recipe_title,
      recipe_image: recipe_image,
      ingredients: ingredients,
      steps: steps,
    }
  end
end
