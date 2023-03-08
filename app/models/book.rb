class Book < ApplicationRecord
  belongs_to :user
  has_many :cards, dependent: :destroy
  validates :title, :chapters, presence: true
  has_one_attached :manuscript

end
