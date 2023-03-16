class Book < ApplicationRecord
  belongs_to :user
  has_many :cards, dependent: :destroy
  validates :title, presence: true
  has_one_attached :manuscript

  enum language_pair: {
    en_ja: 0,
    ja_en: 1
  }
  def how_many_chapters
    if self.cards == []
      'No chapter data'
    else
      chapter_count = self.cards.pluck(:chapter).uniq.max
      chapter_count == 1 ? "There is 1 chapter" : "There are #{chapter_count} chapters"
    end
  end
end
