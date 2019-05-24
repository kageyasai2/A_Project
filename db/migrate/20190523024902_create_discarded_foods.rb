class CreateDiscardedFoods < ActiveRecord::Migration[5.2]
  def change
    create_table :discarded_foods do |t|
      t.string  :name
      t.integer :gram
      t.integer :user_id

      t.timestamps
    end
  end
end