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
    title = "dummy title"
    chapters = 1
    @book.title = title
    @book.chapters = chapters
    @book.user = current_user
    authorize @book
    if @book.save
      # service = EpubConverter.new(@book)
      # service.call
      service = BookToCards.new(@book)
      hash = service.card_creator
      # redirect_to makes an http request to an url
      redirect_to books_path # to change to the edit path once it is up
    else
      # render a file through its path
      render "books/index", status: :unprocessable_entity # to change to the edit once it is up
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :chapters, :manuscript)
  end
end
