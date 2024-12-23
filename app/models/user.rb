class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]
  
  VALID_USERNAMES = %w[contact terms privacy login logout sign_up posts profile settings help about]

  validates :nickname, presence: true, length: { maximum: 30 }
  validates :username, presence: true,
             uniqueness: { case_sensitive: false },
             format: { with: /\A[a-zA-Z0-9_.~-]+\z/, message: "は半角英数字、アンダースコア、ハイフン、ピリオド、チルドのみ使用できます" },
             length: { minimum: 3, maximum: 20 },
             exclusion: { in: VALID_USERNAMES, message: "は使用できません" }
  validates :comment, length: { maximum: 50 }

  has_many :sns_credentials, dependent: :destroy
  has_many :posts
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_one_attached :avatar

  enum :preferred_sweetness, { prefer_mild: 0, prefer_medium_sweet: 1, prefer_sweet: 2 }
  enum :preferred_firmness, { prefer_smooth: 0, prefer_medium_firm: 1, prefer_firm: 2 }

  before_validation :set_default_nickname

  class << self   # ここからクラスメソッド。メソッドの最初につける'self.'を省略できる
    # SnsCredentialsテーブルにデータがないときの処理
    def without_sns_data(auth)
      user = User.where(email: auth.info.email).first

      if user.present?
        sns = SnsCredential.create(
          uid: auth.uid,
          provider: auth.provider,
          user_id: user.id
        )
      else # newは保存までは行わないのでcreateで保存をかける
        user = User.create(
          username: generate_unique_username(auth.info.email.split('@').first),
          nickname: auth.info.name,
          email: auth.info.email,
          password: Devise.friendly_token(10)   # 10文字の予測不能な文字列を生成する
        )
        sns = SnsCredential.create(
          user_id: user.id,
          uid: auth.uid,
          provider: auth.provider
        )
      end
      { user:, sns: }   # ハッシュ形式で呼び出し元に返す
    end

    # SnsCredentialsテーブルにデータがあるときの処理
    def with_sns_data(auth, snscredential)
      user = User.where(id: snscredential.user_id).first
      # 変数userの中身が空文字, 空白文字, false, nilの時の処理
      if user.blank?
        user = User.create(
          username: generate_unique_username(auth.info.email.split('@').first),
          nickname: auth.info.name,
          email: auth.info.email,
          password: Devise.friendly_token(10)
        )
      end
      { user: }
    end

    def generate_unique_username(base_username)
      username = base_username
      counter = 1
      while User.exists?(username: username)
        username = "#{base_username}#{counter}"
        counter += 1
      end
      username
    end    

    # Googleアカウントの情報をそれぞれの変数に格納して上記のメソッドに振り分ける処理
    def find_oauth(auth)
      uid = auth.uid
      provider = auth.provider
      snscredential = SnsCredential.where(uid:, provider:).first
      if snscredential.present?
        user = with_sns_data(auth, snscredential)[:user]
        sns = snscredential
      else
        user = without_sns_data(auth)[:user]
        sns = without_sns_data(auth)[:sns]
      end
      { user:, sns: }
    end
  end

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

  def like(post)
    liked_posts << post
  end
  
  def unlike(post)
    liked_posts.destroy(post)
  end
  
  def like?(post)
    liked_posts.include?(post)
  end

  private

  def set_default_nickname
    self.nickname = username unless nickname.present?
  end
end
