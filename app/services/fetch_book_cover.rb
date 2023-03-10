class FetchBookCover
  def initialize(book)
    @book = book
  end

  def set_book_cover
    url = "https://openlibrary.org/search.json?q=#{URI.encode_www_form_component(@book.title)}"
    book_serialized = URI.open(url).read
    book_url = JSON.parse(book_serialized)
    if book_url["docs"].first.include?('isbn')
      book_isbn = book_url["docs"].first["isbn"][0]
      url = "https://openlibrary.org/api/books?bibkeys=ISBN:#{book_isbn}&format=json&jscmd=data"
      book_serialized = URI.open(url).read
      json_book = JSON.parse(book_serialized)
      book_cover = json_book["ISBN:#{book_isbn}"]
      if json_book["ISBN:#{book_isbn}"].include?("cover")
      @book.image_url = json_book["ISBN:#{book_isbn}"]["cover"]["medium"]
      else
        @book.image_url = "brown-book-cover-texture-1.jpg"
      end
    else
      @book.image_url = "brown-book-cover-texture-1.jpg"
    end
    @book.save
  end
end

# create a method called call

# paste api code in the method

# return the book
