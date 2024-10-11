class Post < ApplicationRecord
  belongs_to :user
  belongs_to :shop, optional: true
  
  validates :body, presence: true, length: { maximum: 555 }
  validates :sweetness, presence: true
  validates :firmness, presence: true
  validates :overall_rating, presence: true

  enum sweetness: { sweet: 0, medium_sweet: 1, mild: 2 }
  enum firmness: { smooth: 0, medium_firm: 1, firm: 2 }
  enum overall_rating: {
  very_poor: 1,
  poor: 2,
  ordinary: 3,
  good: 4,
  excellent: 5
  }

  accepts_nested_attributes_for :shop

  # 将来的に実装予定の機能のためのコメントアウト
  # belongs_to :category
  # has_many :bookmarks
  # has_many :bookmarked_users, through: :bookmarks, source: :user
  def rating_as_integer
    Post.overall_ratings[overall_rating]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["body", "sweetness", "firmness", "overall_rating", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "shop"]
  end
end