require 'active_record'

class UserFood < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }
  belongs_to :user

  scope :where_my, -> (user_id) { where(user_id: user_id) }

  def update_gram_in_user_foods!(gram)
    # UserFoodの消去、または減量
    if gram.blank? || self.gram.to_i <= gram.to_i
      self.destroy
    else
      self.update!(gram: self.gram.to_i - gram.to_i)
    end
  end

  def self.find_from(user_id, food_name)
    food = UserFood.where(user_id: user_id, name: food_name).limit(1)
    if food.blank?
      nil
    else
      food.first
    end
  end

  def self.fetch_foods_into_refrigerator(user_id)
    UserFood.where(user_id: user_id)
  end
end
