class FriendRequest < ApplicationRecord
  validates :requestor_id, presence: true
  validates :requestee_id, presence: true

  belongs_to :requestor, class_name: "User"
  belongs_to :requestee, class_name: "User"
end
