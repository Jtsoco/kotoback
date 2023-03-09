class FetchBookCover
  def initialize(book)
    @book = book
  end

  def set_book_cover
    url = "https://openlibrary.org/search.json?q=#{URI.encode_www_form_component(@book.title)}"
    book_serialized = URI.open(url).read
    book_url = JSON.parse(book_serialized)
    return unless book_url["docs"].present?

    book_isbn = book_url["docs"].first["isbn"][0]

    url = "https://openlibrary.org/api/books?bibkeys=ISBN:#{book_isbn}&format=json&jscmd=data"
    book_serialized = URI.open(url).read
    json_book = JSON.parse(book_serialized)
    book_cover = json_book["ISBN:#{book_isbn}"]

    if book_cover.include?("cover")
      @book.image_url = json_book["ISBN:#{book_isbn}"]["cover"]["medium"]
    else
      @book.image_url = "https://howtodrawforkids.com/wp-content/uploads/2022/07/how-to-draw-an-open-book.jpg"
    end
    @book.save
  end
end

# create a method called call

# paste api code in the method

# return the book
