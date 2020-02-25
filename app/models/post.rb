class Post < ApplicationRecord
  validates :content, presence: true
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  accepts_nested_attributes_for :comments
end
