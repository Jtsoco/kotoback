class BooksController < ApplicationController
  def index
    @books = policy_scope(Book)
    @book = Book.new()
  end

  def study
    @book = Book.find(params[:id])
    authorize @book
  end

  def new
    @book = Book.new(book_params)
  end

  def create
    @book = Book.new(book_params)
    title = 'dummy title'
    chapters = 1
    @book.title = title
    @book.chapters = chapters
    @book.user = current_user
    authorize @book
    if @book.save
      service = EpubConverter.new(@book)
      service.call
      # redirect_to makes an http request to an url
      redirect_to books_path # to change to the edit path once it is up
    else
      # render a file through its path
      render 'books/index', status: :unprocessable_entity # to change to the edit once it is up
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :chapters, :manuscript)
  end
end
