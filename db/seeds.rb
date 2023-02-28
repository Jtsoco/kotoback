# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def fake_user_admin(first_name, last_name)
  user = User.new
  user.email = "#{first_name}@yahoo.com"
  user.first_name = first_name.capitalize
  user.last_name = last_name.capitalize
  user.password = "secret"
  puts user
  user.save
end

User.destroy_all
puts "Creating users"

fake_user_admin("luca", "vigotti")
fake_user_admin("kenta", "asakura")
fake_user_admin("emmanuel", "de la forest")
fake_user_admin("jackson", "scolofsky")

def make_books(index)
  book = Book.new
  book.title = Faker::Book.title
  book.genre = Faker::Book.genre
  book.author = Faker::Book.author
  book.user = User.all[index]
  book.chapters = rand(3..6)
  puts book
  book.save
end

Book.destroy_all
puts "Creating books"

4.times do |i|
  make_books(i)
end

def make_cards
  card = Card.new
  card.book = Book.all.sample
  card.origin_word = "物語"
  card.translation_word = "story, legend"
  puts card
end

Card.destroy_all
puts "Creating cards"

10.times do
  make_cards
end
