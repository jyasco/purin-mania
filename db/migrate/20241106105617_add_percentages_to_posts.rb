class AddPercentagesToPosts < ActiveRecord::Migration[7.2]
  def up
    add_column :posts, :sweetness_percentage, :integer
    add_column :posts, :firmness_percentage, :integer

    # 既存のデータを更新
    Post.reset_column_information
    Post.find_each do |post|
      post.update_columns(
        sweetness_percentage: convert_sweetness_to_percentage(post.sweetness),
        firmness_percentage: convert_firmness_to_percentage(post.firmness)
      )
    end

    # NULL制約を追加
    change_column_null :posts, :sweetness_percentage, false
    change_column_null :posts, :firmness_percentage, false
  end

  def down
    remove_column :posts, :sweetness_percentage
    remove_column :posts, :firmness_percentage
  end

  private

  def convert_sweetness_to_percentage(sweetness)
    case sweetness
    when 'mild' then 25
    when 'medium_sweet' then 50
    when 'sweet' then 75
    else 50 # デフォルト値
    end
  end

  def convert_firmness_to_percentage(firmness)
    case firmness
    when 'smooth' then 25
    when 'medium_firm' then 50
    when 'firm' then 75
    else 50 # デフォルト値
    end
  end
end