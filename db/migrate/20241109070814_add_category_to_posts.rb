class AddCategoryToPosts < ActiveRecord::Migration[7.2]
  def up
    add_column :posts, :category, :integer

    # 既存のすべての投稿を'cafe'カテゴリーに設定
    Post.update_all(category: 0)

    # カラムにNOT NULL制約を追加
    change_column_null :posts, :category, false

    add_index :posts, :category
  end

  def down
    remove_index :posts, :category
    remove_column :posts, :category
  end
end