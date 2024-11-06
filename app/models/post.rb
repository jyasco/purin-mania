class Post < ApplicationRecord
  attr_accessor :shop_name, :shop_address
  
  belongs_to :user
  belongs_to :shop, optional: true
  has_many :bookmarks, dependent: :destroy
  has_one_attached :image

  accepts_nested_attributes_for :shop

  attribute :sweetness_percentage, :integer, default: 50
  attribute :firmness_percentage, :integer, default: 50

  validates :body, presence: true, length: { maximum: 555 }
  validates :sweetness, presence: true
  validates :firmness, presence: true
  validates :overall_rating, presence: true
  validates :sweetness_percentage, :firmness_percentage, presence: true, inclusion: { in: 0..100 }

  enum sweetness: { mild: 0, medium_sweet: 1, sweet: 2 }
  enum firmness: { smooth: 0, medium_firm: 1, firm: 2 }
  enum overall_rating: {
  very_poor: 1,
  poor: 2,
  ordinary: 3,
  good: 4,
  excellent: 5
  }

  before_save :set_sweetness_and_firmness

  # 将来的に実装予定の機能のためのコメントアウト
  # belongs_to :category

  def self.ransackable_attributes(auth_object = nil)
    ["body", "sweetness", "firmness", "overall_rating", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "shop"]
  end
  
  private

  def set_sweetness_and_firmness
    self.sweetness = case sweetness_percentage
                     when 0..33 then 'mild'
                     when 34..66 then 'medium_sweet'
                     else 'sweet'
                     end

    self.firmness = case firmness_percentage
                    when 0..33 then 'smooth'
                    when 34..66 then 'medium_firm'
                    else 'firm'
                    end
  end
end