module CookpadDetailParser
  def parse_recipe_title(doc)
    doc.xpath('//*[@id="recipe-title"]/h1').first.text
  end

  def parse_recipe_image(doc)
    doc.xpath('//*[@id="main-photo"]/img').first.attribute('src').value
  end

  def parse_recipe_ingredients(doc)
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

  def parse_recipe_steps(doc)
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
end
