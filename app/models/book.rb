class Book < ApplicationRecord
  belongs_to :user
  has_many :cards
  validates :title, :chapters, presence: true
  has_one_attached :manuscript
end
