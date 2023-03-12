require "open-uri"

class BooksController < ApplicationController

  def index
    @books = policy_scope(Book)
    @book = Book.new()
  end

  def show
    @book = Book.find(params[:id])
    if params[:chapter].present?
      @cards = @book.cards.where(chapter: params[:chapter])
    else
      @cards = @book.cards.where(chapter: 1)
    end
    @deck = @cards.map { |card| card }
    @unfinished = @cards.where("next_appearance <= ?", DateTime.current)
    if params[:filter].present? && params[:filter] == "unfinished"
      @cards = @unfinished
    elsif params[:filter].present? && params[:filter] == "finished"
      @cards = @deck - @unfinished
    else
      @cards = @deck
    end
    @organized_chapters = @book.cards.pluck(:chapter).uniq.sort
    authorize @book
  end

  def study
    @book = Book.find(params[:id])
    if params[:chapter].present?
      @cards = @book.cards.where(chapter: params[:chapter])
    else
      @cards = @book.cards.where(chapter: 1)
    end
    # compares the database time, to the current time. Both in UTC
    @unfinished = @cards.where("next_appearance <= ?", DateTime.current)
    @array = @unfinished.map { |card| card }
    @organized_chapters = @book.cards.pluck(:chapter).uniq.sort

    authorize @book
  end

  def new
    @book = Book.new(book_params)
  end

  def create

    @book = Book.new(book_params)

    title = "processing"
    @book.title = title
    @book.user = current_user
    @book.processing = false
    authorize @book
    if @book.save
      # service = EpubConverterEng.new(@book)
      # service.call
      BookToCardsJa.perform_later(@book)
      # book_to_cards_ja_trial = BookToCardsJaTrial.new(@book)
      # book_to_cards_ja_trial.card_creator
      # book_to_cards_ja = BookToCardsJa.new(@book)
      # book_to_cards_ja.card_creator

      flash[:notice] = "Your book is processing! It'll be available in 'My Books' in a few minutes"

      # BookToCards.new(@book).card_creator(@book)
      # redirect_to makes an http request to an url
      redirect_to books_path # to change to the edit path once it is up
    else
      # render a file through its path
      render "books/index", status: :unprocessable_entity # to change to the edit once it is up
    end
  end

  def destroy
    @book = Book.find(params[:id])
    authorize @book
    @book.destroy
    redirect_to books_path, status: :see_other
  end

  private

  def book_params
    params.require(:book).permit(:title, :chapters, :manuscript)
  end
end
