class CreateUserfoods < ActiveRecord::Migration[5.2]
  def change
    create_table :userfoods do |t|
      t.string  :name
      t.date    :limit_date
      t.integer :user_id
      t.integer :gram

      t.timestamps
    end
  end
end
