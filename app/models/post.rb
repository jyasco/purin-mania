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
  validates :category, presence: true

  enum :sweetness, { mild: 0, medium_sweet: 1, sweet: 2 }
  enum :firmness, { smooth: 0, medium_firm: 1, firm: 2 }
  enum :overall_rating, {
    very_poor: 1,
    poor: 2,
    ordinary: 3,
    good: 4,
    excellent: 5
  }
  enum category: { cafe: 0, sweets_shop: 1, retail: 2 }, _prefix: true

  before_validation :set_sweetness_and_firmness

  def self.ransackable_attributes(auth_object = nil)
    ["body", "sweetness_percentage", "firmness_percentage", "sweetness", "firmness", "overall_rating", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "shop"]
  end
  
  private

  def set_sweetness_and_firmness
    case sweetness_percentage
    when 0..33
      self.sweetness = 'mild'
    when 34..66
      self.sweetness = 'medium_sweet'
    else
      self.sweetness = 'sweet'
    end
  
    case firmness_percentage
    when 0..33
      self.firmness = 'smooth'
    when 34..66
      self.firmness = 'medium_firm'
    else
      self.firmness = 'firm'
    end
  end
end