class Card < ApplicationRecord
  belongs_to :book
  validates :origin_word, :translation_word, :chapter, presence: true
end
