require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    it '設定した全てのバリデーションが機能しているか' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it 'emailがない場合にバリデーションが機能してinvalidになるか' do
      user_without_email = build(:user, email: "")
      expect(user_without_email).to be_invalid
      expect(user_without_email.errors[:email]).to include("を入力してください")
    end

    it 'usernameがない場合にバリデーションが機能してinvalidになるか' do
      user_without_username = build(:user, username: "")
      expect(user_without_username).to be_invalid
      expect(user_without_username.errors[:username]).to include("を入力してください")
    end

    it 'usernameが指定された形式に従っていない場合バリデーションが機能してinvalidになるか' do
      user_with_invalid_username = build(:user, username: "ユーザーネーム")
      expect(user_with_invalid_username).to be_invalid
      expect(user_with_invalid_username.errors[:username]).to include('は半角英数字、アンダースコア、ハイフン、ピリオド、チルドのみ使用できます')
    end

    it 'usernameが3文字未満の場合バリデーションが機能してinvalidになるか' do
      user_length_missing_username = build(:user, username: "a" * 2)
      expect(user_length_missing_username).to be_invalid
      expect(user_length_missing_username.errors[:username]).to include("は3文字以上で入力してください")
    end

    it 'usernameが20文字を超える場合バリデーションが機能してinvalidになるか' do
      user_with_long_username = build(:user, username: "a" * 21)
      expect(user_with_long_username).to be_invalid
      expect(user_with_long_username.errors[:username]).to include("は20文字以内で入力してください")
    end

    it 'usernameがVALID_USERNAMESリストに含まれる場合バリデーションが機能してinvalidになるか' do
      user_with_invalid_username = build(:user, username: "contact")
      expect(user_with_invalid_username).to be_invalid
      expect(user_with_invalid_username.errors[:username]).to include('は使用できません')
    end

    it '既存のemailが入力された場合バリデーションが機能してinvalidになるか' do
      create(:user, email: "test@example.com")
      user_with_duplicate_email = build(:user, email: "test@example.com")
      expect(user_with_duplicate_email).to be_invalid
      expect(user_with_duplicate_email.errors[:email]).to include("はすでに存在します")
    end

    it '既存のusernameが入力された場合バリデーションが機能してinvalidになるか' do
      create(:user, username: "testuser")
      user_with_duplicate_username = build(:user, username: "testuser")
      expect(user_with_duplicate_username).to be_invalid
      expect(user_with_duplicate_username.errors[:username]).to include("はすでに存在します")
    end

    it 'passwordがない場合にバリデーションが機能してinvalidになるか' do
      user_without_password = build(:user, password: "")
      expect(user_without_password).to be_invalid
      expect(user_without_password.errors[:password]).to include("を入力してください")
    end

    it 'passwordとpassword_confirmationが異なる場合バリデーションが機能してinvalidになるか' do
      user_with_mismatched_passwords = build(:user, password: "password", password_confirmation: "different")
      expect(user_with_mismatched_passwords).to be_invalid
      expect(user_with_mismatched_passwords.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end

    it 'passwordが6文字未満の場合にバリデーションが機能してinvalidになるか' do
      user_length_missing_password = build(:user, password: "a" * 5, password_confirmation: "a" * 5)
      expect(user_length_missing_password).to be_invalid
      expect(user_length_missing_password.errors[:password]).to include("は6文字以上で入力してください")
    end

    it 'nicknameが30文字を超える場合にバリデーションが機能してinvalidになるか' do
      user_with_long_nickname = build(:user, nickname: "a" * 31)
      expect(user_with_long_nickname).to be_invalid
      expect(user_with_long_nickname.errors[:nickname]).to include("は30文字以内で入力してください")
    end

    it 'commentが50文字を超える場合バリデーションが機能してinvalidになるか' do
      user_with_long_comment = build(:user, comment: "a" * 51)
      expect(user_with_long_comment).to be_invalid
      expect(user_with_long_comment.errors[:comment]).to include("は50文字以内で入力してください")
    end
  end

  describe '動作確認' do
    it 'nicknameが設定されていない場合、usernameが設定されるか' do
      user = create(:user, nickname: nil)
      expect(user.nickname).to eq(user.username)
    end
  end
end
