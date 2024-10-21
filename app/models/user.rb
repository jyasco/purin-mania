class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }

  has_many :posts
  has_one_attached :avatar

  def own?(object)
    object&.user_id == id
  end

  def update_avatar(new_avatar)
    avatar.purge if avatar.attached?
    avatar.attach(new_avatar)
  end
end
