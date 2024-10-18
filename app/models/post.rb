class Post < ApplicationRecord
  attr_accessor :shop_name, :shop_address
  
  belongs_to :user
  belongs_to :shop, optional: true
  has_many :post_images, dependent: :destroy

  accepts_nested_attributes_for :shop
  accepts_nested_attributes_for :post_images, allow_destroy: true, reject_if: :all_blank
  
  validates :body, presence: true, length: { maximum: 555 }
  validates :sweetness, presence: true
  validates :firmness, presence: true
  validates :overall_rating, presence: true
  validate :image_count_validation

  enum sweetness: { sweet: 0, medium_sweet: 1, mild: 2 }
  enum firmness: { smooth: 0, medium_firm: 1, firm: 2 }
  enum overall_rating: {
  very_poor: 1,
  poor: 2,
  ordinary: 3,
  good: 4,
  excellent: 5
  }

  # 将来的に実装予定の機能のためのコメントアウト
  # belongs_to :category
  # has_many :bookmarks
  # has_many :bookmarked_users, through: :bookmarks, source: :user

  def self.ransackable_attributes(auth_object = nil)
    ["body", "sweetness", "firmness", "overall_rating", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "shop"]
  end

  private

  def image_count_validation
    errors.add(:post_images, "は3枚まで選択可能です") if post_images.size > 3
  end
  
end