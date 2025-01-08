require 'rails_helper'

RSpec.describe "Posts", type: :system do
  include LoginMacros
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context '投新規投稿ページにアクセス' do
        it '新規投稿ページへのアクセスが失敗する' do
          visit new_post_path
          expect(page).to have_content 'ログインもしくはアカウント登録してください'
          expect(current_path).to eq new_user_session_path
        end
      end

      context '投稿編集ページにアクセス' do
        it '投稿編集ページへのアクセスが失敗する' do
          visit edit_post_path(post)
          expect(page).to have_content 'ログインもしくはアカウント登録してください'
          expect(current_path).to eq new_user_session_path
        end
      end

      context '投稿詳細ページにアクセス' do
        it '投稿詳細ページが表示される' do
          visit post_path(post)
          expect(page).to have_content post.shop.name
          expect(current_path).to eq post_path(post)
        end
      end

      context '投稿一覧ページにアクセス' do
        it '投稿一覧が表示される' do
          post_list = create_list(:post, 3)
          visit posts_path
          expect(page).to have_content post_list[0].shop.name
          expect(page).to have_content post_list[1].shop.name
          expect(page).to have_content post_list[2].shop.name
          expect(current_path).to eq posts_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe '投稿作成' do
      context 'フォームの入力値が正常' do
        it '新規作成が成功する' do
          visit new_post_path
          # フォームに値を入力
          select '洋菓子店', from: 'category-select'
          fill_in 'autocomplete', with: 'test_shop'
          fill_in 'shop_address', with: '東京都千代田区丸の内1-6-5'
          fill_in 'コメント', with: 'a' * 10
          click_button '投稿'
          # 最後に作成された投稿を取得
          new_post = Post.last # 新しく作成された投稿を取得
          expect(page).to have_content '投稿を作成しました'
        end
      end

      context 'カテゴリーが未入力' do
        it '新規作成が失敗する' do
          visit new_post_path
          select '選択してください', from: 'category-select'
          fill_in 'autocomplete', with: 'test_shop'
          fill_in 'コメント', with: 'a'*10
          click_button '投稿'
          expect(page).to have_content '投稿を作成できませんでした'
          expect(page).to have_content 'お店の種類を入力してください'
          expect(current_path).to eq new_post_path
        end
      end

      context '店名が未入力' do
        it '新規作成が失敗する' do
          visit new_post_path
          select '洋菓子店', from: 'category-select'
          fill_in 'autocomplete', with: ''
          fill_in 'shop_address', with: '東京都千代田区丸の内1-6-5'
          fill_in 'コメント', with: 'a'*10
          click_button '投稿'
          expect(page).to have_content '投稿を作成できませんでした'
          expect(page).to have_content 'お店を入力してください'
          expect(current_path).to eq new_post_path
        end
      end

      context 'コメントが未入力' do
        it '新規作成が失敗する' do
          visit new_post_path
          select '洋菓子店', from: 'category-select'
          fill_in 'autocomplete', with: ''
          fill_in 'shop_address', with: '東京都千代田区丸の内1-6-5'
          fill_in 'コメント', with: ''
          click_button '投稿'
          expect(page).to have_content '投稿を作成できませんでした'
          expect(page).to have_content 'コメントを入力してください'
          expect(current_path).to eq new_post_path
        end
      end
    end

    describe '投稿編集' do
      let!(:post) { create(:post, user: user) } # 現在のユーザーに関連付けて投稿を作成
      before { visit edit_post_path(post) }

      context 'フォームの入力値が正常' do
        it '投稿編集が成功する' do
          select '洋菓子店', from: 'category-select'
          fill_in 'autocomplete', with: 'test_shop'
          fill_in 'コメント', with: 'a'*10
          click_button '投稿'
          expect(page).to have_content '投稿を更新しました'
          expect(current_path).to eq post_path(post)
        end
      end

      context '店名が未入力' do
        it '投稿編集が失敗する' do
          select '洋菓子店', from: 'category-select'
          fill_in 'autocomplete', with: ''
          fill_in 'コメント', with: 'a'*10
          click_button '投稿'
          expect(page).to have_content '投稿を更新できませんでした'
          expect(page).to have_content 'お店を入力してください'
          expect(current_path).to eq edit_post_path(post)
        end
      end

      context 'コメントが未入力' do
        it '投稿編集が失敗する' do
          select '洋菓子店', from: 'category-select'
          fill_in 'autocomplete', with: 'test_shop'
          fill_in 'コメント', with: ''
          click_button '投稿'
          expect(page).to have_content '投稿を更新できませんでした'
          expect(page).to have_content 'コメントを入力してください'
          expect(current_path).to eq edit_post_path(post)
        end
      end
    end

    describe '投稿削除' do
      let!(:post) { create(:post, user: user) }
      it '投稿削除が成功する' do
        visit posts_path
        click_link "button-delete-#{post.id}"
        expect(page.accept_confirm).to eq '削除しますか？'
        expect(page).to have_content '投稿を削除しました'
        expect(current_path).to eq posts_path
        expect(page).not_to have_content post.shop.name
      end
    end
  end
end
