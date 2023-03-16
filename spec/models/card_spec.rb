require 'rails_helper'
RSpec.describe Card, type: :model do
  describe '#initialize' do
    let(:user) {User.create(email: "tim@yahoo.com", first_name: "tim", last_name: "tom", password: "secret")}
    let(:book) {Book.create(title: 'title', user: user , processing: false )}
    let(:card) {Card.new(book: book, origin_word: "hello", translation_word: "こんにちは", chapter: 1)}
    it 'is valid with all columns present' do
      expect(card.valid?).to eq(true)
    end
    context 'with missing chapter' do
      before do
        card.chapter = nil
      end
      it 'is not valid' do
        expect(card.valid?).to eq(false)
      end
    end
    context 'with missing chapter' do
      before do
        card.chapter = nil
      end
      it 'returns error message with missing chapter' do
        card.valid?
        expect(card.errors.messages).to eq(chapter: ["can't be blank"])
      end
    end
  end
end
# note: rpsec expects all your spec files to be in the same convention as in the app. spec -> models -> model_spec.rb
# Look into continuous integration! It's important for backend devs
