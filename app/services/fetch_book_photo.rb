# define a class with the same name as a file
# create initialize method
# create book variable inside initialize
class FetchBookPhoto
  def initialize(book)
    @book = book
  end

  # def call
  #   url = "https://openlibrary.org/search.json?q=starwars"
  #   book_serialized = URI.open(url).read
  #   book = JSON.parse(book_serialized)
  #   book_isbn = book['docs'].first['isbn'][0]

  #   url = "https://openlibrary.org/api/books?bibkeys=ISBN:#{book_isbn}&format=json&jscmd=data"
  #   book_serialized = URI.open(url).read
  #   book = JSON.parse(book_serialized)
  #   @book.image_url = book["ISBN:#{book_isbn}"]['cover']['medium']
  # end
end

# create a method called call

# paste api code in the method

# return the book
