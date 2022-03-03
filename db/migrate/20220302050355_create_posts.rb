class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.date :date_of_post,  null: false
      t.boolean :select_yen, null: false, default: false
      t.integer :price,      null: false
      t.string :memo_1
      t.string :memo_2
      t.references :user,    null: false, foreign_key: true
      t.timestamps
    end
  end
end
