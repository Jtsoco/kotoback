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
    @organized_chapters = @book.cards.pluck(:chapter).uniq
    authorize @book
  end

  def study
    @book = Book.find(params[:id])
    if params[:chapter].present?
      @cards = @book.cards.where(chapter: params[:chapter])
    else
      @cards = @book.cards.where(chapter: 1)
    end
    @array = @cards.map { |card| card }
    @organized_chapters = @book.cards.pluck(:chapter).uniq
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

    # url = "https://openlibrary.org/search.json?q=#{@book.title}"
    # book_serialized = URI.open(url).read
    # book_url = JSON.parse(book_serialized)
    # book_isbn = book_url["docs"].first["isbn"][0]

    # url = "https://openlibrary.org/api/books?bibkeys=ISBN:#{book_isbn}&format=json&jscmd=data"
    # book_serialized = URI.open(url).read
    # json_book = JSON.parse(book_serialized)
    # book_cover = json_book["ISBN:#{book_isbn}"]

    # if book_cover.include?("cover")
    #   @book.image_url = json_book["ISBN:#{book_isbn}"]["cover"]["medium"]
    # else
    #   @book.image_url = "https://howtodrawforkids.com/wp-content/uploads/2022/07/how-to-draw-an-open-book.jpg"
    # end

    # refactor by using service
    # book = FetchBookCover.new(@book)
    # @book.image_url = set_book_cover(book.title)

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
