class Shop < ApplicationRecord
  has_many :posts
  
  validates :name, presence: true, length: { maximum: 255 }
  validates :address, allow_blank: true, length: { maximum: 255 }

  # 将来的に実装予定の機能のためのコメントアウト
  # geocoded_by :address
  # after_validation :geocode, if: :address_changed?

  def self.ransackable_attributes(auth_object = nil)
    ["name", "address"]
  end

end
