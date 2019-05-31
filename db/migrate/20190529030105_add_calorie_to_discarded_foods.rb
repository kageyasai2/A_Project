class AddCalorieToDiscardedFoods < ActiveRecord::Migration[5.2]
  def change
    add_column :discarded_foods, :calorie, :integer
  end
end
