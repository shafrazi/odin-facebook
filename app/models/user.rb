class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook]
  validates :name, presence: true
  has_many :posts
  has_many :friendships
  has_many :friends, through: :friendships
  # has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  # has_many :inverse_friends, through: :inverse_friendships, source: :user

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end

  def is_friend?(other_user)
    self.friends.include?(other_user)
  end
end
