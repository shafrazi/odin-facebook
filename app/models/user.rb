class User < ApplicationRecord
  after_create :send_welcome_mail
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

  has_one_attached :avatar

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

  def add_friend(other_user)
    self.friendships.create(friend_id: other_user.id)
  end

  def request_count
    self.received_friend_requests.count if self.received_friend_requests.any?
  end

  def feed
    friend_ids = "SELECT friend_id FROM friendships WHERE user_id = :user_id"
    Post.where("user_id IN (#{friend_ids}) OR user_id = :user_id", user_id: self.id).order(created_at: :desc)
  end

  def liked?(post)
    Like.find_by(post_id: post.id, user_id: self.id)
  end

  def photos
    photos = []
    self.posts.each do |post|
      if post.photo.attached?
        photos << post.photo
      end
    end
    photos
  end

  def friend_request_sent?(other_user)
    FriendRequest.find_by(requestor_id: self.id, requestee_id: other_user.id)
  end

  def friend_request_received?(other_user)
    FriendRequest.find_by(requestor_id: other_user.id, requestee_id: self.id)
  end

  private

  def send_welcome_mail
    UserMailer.welcome(self).deliver_now
  end
end
