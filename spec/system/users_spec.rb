require 'rails_helper'

RSpec.describe 'Users', type: :system do
  include LoginMacros
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit new_user_registration_path
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'ユーザー名', with: 'test_user'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード（確認）', with: 'password'
          click_button '登録'
          expect(page).to have_content 'アカウント登録が完了しました'
          expect(current_path).to eq root_path
        end
      end

      context 'ユーザー名が未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_registration_path
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'ユーザー名', with: ''
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード（確認）', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー名を入力してください'
          expect(page).to have_content 'ユーザー名は半角英数字、アンダースコア、ハイフン、ピリオド、チルドのみ使用できます'
          expect(page).to have_content 'ユーザー名は3文字以上で入力してください'
          expect(current_path).to eq new_user_registration_path
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_registration_path
          fill_in 'メールアドレス', with: ''
          fill_in 'ユーザー名', with: 'test_user'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード（確認）', with: 'password'
          click_button '登録'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(current_path).to eq new_user_registration_path
        end
      end

      context '登録済のユーザー名を使用' do
        it 'ユーザーの新規作成が失敗する' do
          existed_user = create(:user)
          visit new_user_registration_path
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'ユーザー名', with: existed_user.username
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード（確認）', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー名はすでに存在します'
          expect(current_path).to eq new_user_registration_path
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          existed_user = create(:user)
          visit new_user_registration_path
          fill_in 'メールアドレス', with: existed_user.email
          fill_in 'ユーザー名', with: 'test_user'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード（確認）', with: 'password'
          click_button '登録'
          expect(page).to have_content 'メールアドレスはすでに存在します'
          expect(current_path).to eq new_user_registration_path
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit mypage_mypage_path
          expect(page).to have_content 'ログインもしくはアカウント登録してください'
          expect(current_path).to eq new_user_session_path
        end
      end
    end

    describe '投稿作成' do
      context 'ログインしていない状態' do
        it '投稿作成ページへのアクセスが失敗する' do
          visit new_post_path
          expect(page).to have_content 'ログインもしくはアカウント登録してください'
          expect(current_path).to eq new_user_session_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_registration_path
          fill_in '名前', with: 'テストユーザー'
          fill_in 'ユーザー名', with: 'test_user'
          fill_in 'メールアドレス', with: 'update@example.com'
          select 'ほどよい', from: '甘さの好み'
          select 'かため', from: '固さの好み'
          # 画像ファイルを指定してアップロード
          attach_file('プロフィール画像', Rails.root.join('spec/fixtures/test_image.jpg'))
          fill_in 'ひとこと', with: 'a' * 10
          click_button '更新'
          expect(page).to have_content 'プロフィールを更新しました'
          expect(current_path).to eq mypage_mypage_path
        end
      end

      context '名前が未入力' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_registration_path
          fill_in '名前', with: ''
          fill_in 'ユーザー名', with: 'test_user'
          fill_in 'メールアドレス', with: 'update@example.com'
          select 'ほどよい', from: '甘さの好み'
          select 'かため', from: '固さの好み'
          # 画像ファイルを指定してアップロード
          attach_file('プロフィール画像', Rails.root.join('spec/fixtures/test_image.jpg'))
          fill_in 'ひとこと', with: 'a' * 10
          click_button '更新'
          expect(page).to have_content 'プロフィールを更新しました'
          expect(current_path).to eq mypage_mypage_path
        end
      end

      context 'ユーザー名が未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_registration_path
          fill_in '名前', with: 'テストユーザー'
          fill_in 'ユーザー名', with: ''
          fill_in 'メールアドレス', with: 'update@example.com'
          select 'ほどよい', from: '甘さの好み'
          select 'かため', from: '固さの好み'
          # 画像ファイルを指定してアップロード
          attach_file('プロフィール画像', Rails.root.join('spec/fixtures/test_image.jpg'))
          fill_in 'ひとこと', with: 'a' * 10
          click_button '更新'
          expect(page).to have_content 'エラーが発生したため ユーザー は保存されませんでした'
          expect(page).to have_content 'ユーザー名を入力してください'
          expect(current_path).to eq edit_user_registration_path
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_registration_path
          fill_in '名前', with: 'テストユーザー'
          fill_in 'ユーザー名', with: 'test_user'
          fill_in 'メールアドレス', with: ''
          select 'ほどよい', from: '甘さの好み'
          select 'かため', from: '固さの好み'
          # 画像ファイルを指定してアップロード
          attach_file('プロフィール画像', Rails.root.join('spec/fixtures/test_image.jpg'))
          fill_in 'ひとこと', with: 'a' * 10
          click_button '更新'
          expect(page).to have_content 'エラーが発生したため ユーザー は保存されませんでした'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(current_path).to eq edit_user_registration_path
        end
      end

      context '甘さの好みが未入力' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_registration_path
          fill_in '名前', with: 'テストユーザー'
          fill_in 'ユーザー名', with: 'test_user'
          fill_in 'メールアドレス', with: 'update@example.com'
          select '未設定', from: '甘さの好み'
          select 'かため', from: '固さの好み'
          # 画像ファイルを指定してアップロード
          attach_file('プロフィール画像', Rails.root.join('spec/fixtures/test_image.jpg'))
          fill_in 'ひとこと', with: 'a' * 10
          click_button '更新'
          expect(page).to have_content 'プロフィールを更新しました'
          expect(current_path).to eq mypage_mypage_path
        end
      end

      context '固さの好みが未入力' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_registration_path
          fill_in '名前', with: 'テストユーザー'
          fill_in 'ユーザー名', with: 'test_user'
          fill_in 'メールアドレス', with: 'update@example.com'
          select 'ほどよい', from: '甘さの好み'
          select '未設定', from: '固さの好み'
          # 画像ファイルを指定してアップロード
          attach_file('プロフィール画像', Rails.root.join('spec/fixtures/test_image.jpg'))
          fill_in 'ひとこと', with: 'a' * 10
          click_button '更新'
          expect(page).to have_content 'プロフィールを更新しました'
          expect(current_path).to eq mypage_mypage_path
        end
      end

      context '画像が未アップロード' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_registration_path
          fill_in '名前', with: 'テストユーザー'
          fill_in 'ユーザー名', with: 'test_user'
          fill_in 'メールアドレス', with: 'update@example.com'
          select 'ほどよい', from: '甘さの好み'
          select 'かため', from: '固さの好み'
          fill_in 'ひとこと', with: 'a' * 10
          click_button '更新'
          expect(page).to have_content 'プロフィールを更新しました'
          expect(current_path).to eq mypage_mypage_path
        end
      end

      context 'ひとことが未入力' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_registration_path
          fill_in '名前', with: 'テストユーザー'
          fill_in 'ユーザー名', with: 'test_user'
          fill_in 'メールアドレス', with: 'update@example.com'
          select 'ほどよい', from: '甘さの好み'
          select 'かため', from: '固さの好み'
          # 画像ファイルを指定してアップロード
          attach_file('プロフィール画像', Rails.root.join('spec/fixtures/test_image.jpg'))
          fill_in 'ひとこと', with: ''
          click_button '更新'
          expect(page).to have_content 'プロフィールを更新しました'
          expect(current_path).to eq mypage_mypage_path
        end
      end

      context '登録済のユーザー名を使用' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_registration_path
          existed_user = create(:user)
          fill_in '名前', with: 'テストユーザー'
          fill_in 'ユーザー名', with: existed_user.username
          fill_in 'メールアドレス', with: 'update@example.com'
          select 'ほどよい', from: '甘さの好み'
          select 'かため', from: '固さの好み'
          # 画像ファイルを指定してアップロード
          attach_file('プロフィール画像', Rails.root.join('spec/fixtures/test_image.jpg'))
          fill_in 'ひとこと', with: 'a' * 10
          click_button '更新'
          expect(page).to have_content 'エラーが発生したため ユーザー は保存されませんでした'
          expect(page).to have_content 'ユーザー名はすでに存在します'
          expect(current_path).to eq edit_user_registration_path
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_registration_path
          existed_user = create(:user)
          fill_in '名前', with: 'テストユーザー'
          fill_in 'ユーザー名', with: 'test_user'
          fill_in 'メールアドレス', with: existed_user.email
          select 'ほどよい', from: '甘さの好み'
          select 'かため', from: '固さの好み'
          # 画像ファイルを指定してアップロード
          attach_file('プロフィール画像', Rails.root.join('spec/fixtures/test_image.jpg'))
          fill_in 'ひとこと', with: 'a' * 10
          click_button '更新'
          expect(page).to have_content 'エラーが発生したため ユーザー は保存されませんでした'
          expect(page).to have_content 'メールアドレスはすでに存在します'
          expect(current_path).to eq edit_user_registration_path
        end
      end
    end
  end
end
