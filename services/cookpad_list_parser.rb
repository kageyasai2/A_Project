module CookpadListParser
  def parse_recipes(doc)
    doc.xpath('//*[@id="main_content"]/div[5]/div[@class="recipe-preview"]')
  end

  def parse_recipe_title(doc)
    doc.xpath('.//div[@class="recipe-text"]/span[@class="title font16"]').text
  end

  def parse_recipe_link(doc)
    doc.xpath('.//div[@class="recipe-text"]/span[@class="title font16"]/a').attribute('href').value
  end

  def parse_recipe_thumbnail(doc)
    doc.xpath('.//div[@class="recipe-image wide"]/a/img').attribute('src').value
  end

  def parse_recipe_ingredients(doc)
    doc.xpath('.//div[@class="recipe-text"]/div[@class="material ingredients"]').text
  end
  
end
