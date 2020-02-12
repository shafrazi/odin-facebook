class Friendship < ApplicationRecord
  after_create :inverse_friendship_create
  after_destroy :inverse_friendship_destroy

  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user_id, presence: true
  validates :friend_id, presence: true

  private

  def inverse_friendship_create
    attributes = { user_id: self.friend_id, friend_id: self.user_id }
    unless Friendship.find_by(attributes)
      Friendship.create(attributes)
    end
  end

  def inverse_friendship_destroy
    attributes = { user_id: self.friend_id, friend_id: self.user_id }
    if Friendship.find_by(attributes)
      friendship = Friendship.find_by(attributes)
      friendship.destroy
    end
  end
end
