FactoryBot.define do
  factory :post do
    body { "body" }
    sweetness_percentage { rand(0..100) }
    firmness_percentage { rand(0..100) }
    overall_rating { Post.overall_ratings.keys.sample }
    category { Post.categories.keys.sample }

    # sweetness と firmness は before_validation で自動設定されるため、ここでは設定しない
    
    # 関連付け
    association :user
    association :shop

    # カテゴリーに応じてshopの関連付けを調整
    after(:build) do |post|
      if post.category == 'retail'
        post.shop.address = nil
      else
        post.shop ||= build(:shop)
      end
    end

    # 画像の添付
    after(:build) do |post|
      post.image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'test_image.jpg')), filename: 'test_image.jpg', content_type: 'image/jpeg')
    end
  end
end
