class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook]
  validates :name, presence: true

  has_many :posts, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :comments, dependent: :destroy

  has_many :likes, dependent: :destroy

  has_many :sent_friend_requests, class_name: "FriendRequest", foreign_key: :requestor_id
  has_many :received_friend_requests, class_name: "FriendRequest", foreign_key: :requestee_id

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

  def request_count
    self.received_friend_requests.count if self.received_friend_requests.any?
  end

  def feed
    friend_ids = "SELECT friend_id FROM friendships WHERE user_id = :user_id"
    Post.where("user_id IN (#{friend_ids}) OR user_id = :user_id", user_id: self.id)
  end

  def liked?(post)
    Like.find_by(post_id: post.id, user_id: self.id)
  end
end
