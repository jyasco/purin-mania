class AddPreferencesToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :comment, :text
    add_column :users, :preferred_sweetness, :integer
    add_column :users, :preferred_firmness, :integer
  end
end
