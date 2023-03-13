class Book < ApplicationRecord
  belongs_to :user
  has_many :cards, dependent: :destroy
  validates :title, presence: true
  has_one_attached :manuscript

  enum language_pair: {
    en_ja: 0,
    ja_en: 1
  }

end
