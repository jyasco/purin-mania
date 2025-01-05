class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shop, null: true, foreign_key: true
      t.text :body, null: false
      t.integer :sweetness, null: false
      t.integer :firmness, null: false
      t.integer :overall_rating, null: false, default: 1

      t.timestamps
    end

    add_index :posts, %i[shop_id user_id]
    add_index :posts, :sweetness
    add_index :posts, :firmness
    add_index :posts, :overall_rating
  end
end
