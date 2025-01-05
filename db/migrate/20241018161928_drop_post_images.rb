class DropPostImages < ActiveRecord::Migration[7.2]
  def up
    drop_table :post_images
  end

  def down
    create_table :post_images do |t|
      t.references :post, foreign_key: true
      t.string :image

      t.timestamps
    end
  end
end
