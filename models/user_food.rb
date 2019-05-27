require 'active_record'

class UserFood < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }
  belongs_to :user

  def update_gram_in_user_foods(food,gram)
    # UserFoodの消去、または減量
    food = food.first
    if gram.blank? || food.gram.to_i <= gram.to_i
      food.destroy
    else
      food.update!(gram: food.gram.to_i - gram.to_i)
    end
  end

end
