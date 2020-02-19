class Post < ApplicationRecord
  validates :content, presence: true
  belongs_to :user
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :comments
end
