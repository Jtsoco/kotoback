# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.destroy_all
Book.destroy_all
Card.destroy_all

def fake_user_admin(first_name, last_name)
  user = User.new
  user.email = "#{first_name}@yahoo.com"
  user.first_name = first_name.capitalize
  user.last_name = last_name.capitalize
  user.password = "secret"
  puts user
  user.save
end

puts "Creating users"
fake_user_admin("luca", "vigotti")
fake_user_admin("kenta", "asakura")
fake_user_admin("emmanuel", "de la forest")
fake_user_admin("jackson", "scolofsky")

BOOK_TITLES = ["Harry Potter and the Chamber of Secrets",
               "Little Bear",
               "Gone Girl",
               "The Help"]

def make_books(index)
  book = Book.new
  book.title = BOOK_TITLES.sample
  book.genre = Faker::Book.genre
  book.author = Faker::Book.author

  # for testing purposes
  # https://openlibrary.org/search.json?q=
  # 9780606204910
  # littlebear = 9780140315684
  # gonegirl = 359652072X
  # the help = 9781089419099
  # "https://openlibrary.org/api/books?bibkeys=ISBN:9780606204910&format=json&jscmd=data"
  # json_book["ISBN:9780606204910"]['cover']['medium']

  url = "https://openlibrary.org/search.json?q=#{book.title}"
  book_serialized = URI.open(url).read
  book_url = JSON.parse(book_serialized)
  book_isbn = book_url["docs"].first["isbn"][0]

  url = "https://openlibrary.org/api/books?bibkeys=ISBN:#{book_isbn}&format=json&jscmd=data"
  book_serialized = URI.open(url).read
  json_book = JSON.parse(book_serialized)
  book_cover = json_book["ISBN:#{book_isbn}"]

  if book_cover.include?("cover")
    book.image_url = json_book["ISBN:#{book_isbn}"]["cover"]["medium"]
  else
    book.image_url = "https://howtodrawforkids.com/wp-content/uploads/2022/07/how-to-draw-an-open-book.jpg"
  end

  book.user = User.all[index]
  book.chapters = 2
  puts book
  book.save
end

# puts "Creating books"

# User.all.each do
#   4.times do |i|
#     make_books(i)
#   end
# end

# words = [{ origin: "必要", translation: "necessary" },
#          { origin: "奇跡", translation: "miracle" },
#          { origin: "速度", translation: "speed" },
#          { origin: "純正", translation: "genuine" },
#          { origin: "達人", translation: "master" },
#          { origin: "合法", translation: "legal" },
#          { origin: "危険", translation: "dangerous" },
#          { origin: "能力", translation: "ability" },
#          { origin: "重力", translation: "gravity" },
#          { origin: "落下", translation: "fall" }]

# def make_cards(japanese, english, book)
#   card = Card.new
#   card.book = book
#   card.origin_word = japanese
#   card.translation_word = english
#   puts card
#   card.save
# end

# puts "Creating cards"
# words.each do |word|
#   Book.all.each do |book|
#     make_cards(word[:origin], word[:translation], book)
#   end
# end
