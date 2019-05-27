require 'active_record'

class DiscardedFood < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }
  belongs_to :user

  def save_discarded_foods(discarded_food_list,user_id)
    DiscardedFood.transaction do
      discarded_food_list.each do |item|
        gram = item[:gram]

        # 廃棄食材の登録
        discarded_food = DiscardedFood.new({
          name:    item[:food_name],
          gram:    gram,
          user_id: user_id,
        })
        discarded_food.save!

        food = UserFood.where(user_id: user_id, name: item[:food_name]).limit(1)

        if food.blank?
          next
        end
            
        UserFood.new().update_gram_in_user_foods(food,gram)
      end
    rescue ActiveRecord::RecordInvalid
      false
    end

  end
end