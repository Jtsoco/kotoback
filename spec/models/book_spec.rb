require 'rails_helper'
RSpec.describe Book, type: :model do
  let(:user) {User.create(email: "tim@yahoo.com", first_name: "tim", last_name: "tom", password: "secret")}
  let(:book) {Book.new(title: 'title', user: user , processing: false )}
  let(:book_saved) {Book.create(title: 'title', user: user , processing: false )}
  let(:card) {Card.create(book: book_saved, origin_word: "hello", translation_word: "こんにちは", chapter: 1)}
  describe '#initialize' do
    it 'is valid with all columns present' do
      expect(book.valid?).to eq(true)
    end
    context 'with missing title' do
      before do
          book.title = nil
      end
      it 'is not valid without title' do
        expect(book.valid?).to eq(false)
      end
    end
    context 'with missing title' do
      before do
          book.title = nil
      end
      it 'returns error message with missing title' do
        book.valid?
        expect(book.errors.messages).to eq(title: ["can't be blank"])
      end
    end
    # before do
    #     book.title = nil
    # end
    # it 'returns error message with missing title' do
    #   book.valid?
    #   expect(book.errors.messages).to eq()
    # end
  end
  describe '#how_many_chapters' do

    context 'with no cards' do
      it 'returns message "No chapter data' do
        expect(book.how_many_chapters).to eq("No chapter data")
      end
    end
    context 'with no cards' do
      it 'Returns "There is 1 chapter"' do
        book_saved = card.book
        expect(book_saved.how_many_chapters).to eq("There is 1 chapter")
      end
    end
  end

end
# Rspec.describe Book, type: :model do
#   describe '#initialize' do
#     it 'is valid with all columns present' do
#       book = Book.new(title: 'title', user: User.first, processing: false, )
#       expect(book.valid?).to eq(true)
#     end
#     it 'retursn error message with missing title' do
#       book = Book.new()
#       expect(book.valid?).to eq(false)
#     end
#   end
# end
