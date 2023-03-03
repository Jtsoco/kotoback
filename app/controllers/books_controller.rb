require "open-uri"

class BooksController < ApplicationController
  def index
    @books = policy_scope(Book)
    @book = Book.new()
  end

  def study
    @book = Book.find(params[:id])
    
    @cards = @book.cards

    @array = @cards.map { |card| card }
    @organized_chapters = @book.cards.pluck(:chapter)
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

    # url = "https://openlibrary.org/search.json?q=#{@book.user}"
    # book_serialized = URI.open(url).read
    # book = JSON.parse(book_serialized)

    # book_isbn = book['docs'].first['isbn'][0]


    # url = "https://openlibrary.org/api/books?bibkeys=ISBN:#{book_isbn}&format=json&jscmd=data"
    # book_serialized = URI.open(url).read
    # book = JSON.parse(book_serialized)

    # @book.image_url = book["ISBN:#{book_isbn}"]['cover']['medium']


    # refactor by using service
    # @book = FetchBookPhoto.new(@book).call

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
