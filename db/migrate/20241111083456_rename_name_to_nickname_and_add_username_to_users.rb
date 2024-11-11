class RenameNameToNicknameAndAddUsernameToUsers < ActiveRecord::Migration[7.2]
  def change
    # 既存のnameカラムをnicknameにリネーム
    rename_column :users, :name, :nickname

    # usernameカラムを追加（NULLを許可）
    add_column :users, :username, :string, null: true

    # usernameカラムにユニークインデックスを追加
    add_index :users, :username, unique: true

    reversible do |dir|
      dir.up do
        User.reset_column_information # カラムの変更を反映
        User.find_each do |user|
          user.update(username: user.email.split('@').first) # メールアドレスの@より前をusernameに設定
        end

        # usernameカラムにNOT NULL制約を追加
        change_column_null :users, :username, false
      end

      dir.down do
        # 元に戻す処理
        remove_column :users, :username
      end
    end
  end
end