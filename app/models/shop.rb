class Shop < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :address, allow_blank: true, length: { maximum: 255 }

  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.address_changed? }

  def self.ransackable_attributes(auth_object = nil)
    %w[name address]
  end
end
