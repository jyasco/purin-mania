class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }

  has_many :posts
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_one_attached :avatar

  enum :preferred_sweetness, { prefer_mild: 0, prefer_medium_sweet: 1, prefer_sweet: 2 }
  enum :preferred_firmness, { prefer_smooth: 0, prefer_medium_firm: 1, prefer_firm: 2 }

  def own?(object)
    object&.user_id == id
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  def update_avatar(new_avatar)
    avatar.purge if avatar.attached?
    avatar.attach(new_avatar)
  end

  def bookmark(post)
    bookmark_posts << post
  end

  def unbookmark(post)
    bookmark_posts.destroy(post)
  end

  def bookmark?(post)
    bookmark_posts.include?(post)
  end
end
