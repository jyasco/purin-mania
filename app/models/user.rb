class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  VALID_USERNAMES = %w[contact terms privacy login logout sign_up posts profile settings help about]

  validates :nickname, presence: true, length: { maximum: 30 }
  validates :username, presence: true,
             uniqueness: { case_sensitive: false },
             format: { with: /\A[a-zA-Z0-9_.~-]+\z/, message: "は半角英数字、アンダースコア、ハイフン、ピリオド、チルドのみ使用できます" },
             length: { minimum: 3, maximum: 20 },
             exclusion: { in: VALID_USERNAMES, message: "は使用できません" }
  validates :comment, length: { maximum: 50 }

  has_many :posts
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_one_attached :avatar

  enum :preferred_sweetness, { prefer_mild: 0, prefer_medium_sweet: 1, prefer_sweet: 2 }
  enum :preferred_firmness, { prefer_smooth: 0, prefer_medium_firm: 1, prefer_firm: 2 }

  before_validation :set_default_nickname

  def own?(object)
    object&.user_id == id
  end

  def self.ransackable_attributes(auth_object = nil)
    ["nickname","username"]
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

  private

  def set_default_nickname
    self.nickname = username unless nickname.present?
  end
end
