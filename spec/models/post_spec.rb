require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーションチェック' do
    it '設定した全てのバリデーションが機能しているか' do
      post = build(:post)
      expect(post).to be_valid
      expect(post.errors).to be_empty
    end

    it 'categoryが未選択の場合バリデーションが機能してinvalidになるか' do
      post_without_category = build(:post, category: "")
      expect(post_without_category).to be_invalid
      expect(post_without_category.errors[:category]).to include("を入力してください")
    end

    it 'shop.nameが未入力の場合バリデーションが機能してinvalidになるか' do
      post_without_shop = build(:post) # Postオブジェクトを作成
      post_without_shop.shop = build(:shop, name: "") # shopを作成し、nameを空に設定
      expect(post_without_shop).to be_invalid # Postオブジェクトが無効であることを期待
      expect(post_without_shop.shop.errors[:name]).to include("を入力してください") # shopのnameエラーを確認
    end

    it 'bodyが未入力の場合バリデーションが機能してinvalidになるか' do
      post_without_body = build(:post, body: "")
      expect(post_without_body).to be_invalid
      expect(post_without_body.errors[:body]).to include("を入力してください")
    end

    it 'bodyが555文字を超える場合バリデーションが機能してinvalidになるか' do
      post_long_body = build(:post, body: "a" * 556)
      expect(post_long_body).to be_invalid
      expect(post_long_body.errors[:body]).to include("は555文字以内で入力してください")
    end
  end

  describe 'カテゴリーと住所の関係' do
    it 'categoryがretailの場合shop.addressが空の状態で保存されるか' do
      post = build(:post, category: :retail, shop: build(:shop, address: '東京都渋谷区'))
      post.save
      expect(post.shop.address).to be_nil
    end

    it 'categoryがcafeまたはsweets_shopの場合、shop.addressが正しく保存されるか' do
      %i[cafe sweets_shop].each do |category|
        post = build(:post, category: category, shop: build(:shop, address: '東京都渋谷区'))
        post.save
        expect(post.shop.address).to eq '東京都渋谷区'
      end
    end
  end

  describe '甘さと固さの設定' do
    it 'sweetnessがsweetness_percentageに基づいて正しく設定されているか' do
      {
        0 => :mild,
        33 => :mild,
        34 => :medium_sweet,
        66 => :medium_sweet,
        67 => :sweet,
        100 => :sweet
      }.each do |percentage, expected_sweetness|
        post = build(:post, sweetness_percentage: percentage)
        post.save
        expect(post.sweetness.to_sym).to eq expected_sweetness
      end
    end
    
    it 'firmnessがfirmness_percentageに基づいて正しく設定されているか' do
      {
        0 => :smooth,
        33 => :smooth,
        34 => :medium_firm,
        66 => :medium_firm,
        67 => :firm,
        100 => :firm
      }.each do |percentage, expected_firmness|
        post = build(:post, firmness_percentage: percentage)
        post.save
        expect(post.firmness.to_sym).to eq expected_firmness
      end
    end    
  end
end
