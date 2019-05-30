class AddCalorieToUserFoods < ActiveRecord::Migration[5.2]
  def change
    add_column :user_foods, :calorie, :integer
  end
end
