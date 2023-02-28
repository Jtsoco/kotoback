class BooksController < ApplicationController
  def index
    @books = policy_scope(Book)
  end

  def study
  end

  def new
    @book = Book.new(book_params)
  end

  def create
    @book = Book.new(book_params)
    authorize @book
    if @book.save
      redirect_to 'books_edit'
    else
      render 'books_edit', status: :unprocessable_entity
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :chapters, :manuscript)
  end
end
