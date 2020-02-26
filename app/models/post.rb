class Post < ApplicationRecord
  validates :content, presence: true
  validate :image_content_type
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  accepts_nested_attributes_for :comments

  has_one_attached :photo

  private

  def image_content_type
    if self.photo.attached? && !self.photo.blob.content_type.starts_with?("image/")
      errors.add(:photo, "should be an image")
    end
  end
end
