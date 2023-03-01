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

puts 'Creating users'
fake_user_admin('luca', 'vigotti')
fake_user_admin('kenta', 'asakura')
fake_user_admin('emmanuel', 'de la forest')
fake_user_admin('jackson', 'scolofsky')

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
  book.chapters = 2
  puts book
  book.save
end

puts 'Creating books'
4.times do |i|
  make_books(i)
end

words = [{origin: '必要', translation: 'necessary'},
  {origin: '奇跡', translation: 'miracle'},
  {origin: '速度', translation: 'speed'},
  {origin: '純正', translation: 'genuine'},
  {origin: '達人', translation: 'master'},
  {origin: '合法', translation: 'legal'},
  {origin: '危険', translation: 'dangerous'},
  {origin: '能力', translation: 'ability'},
  {origin: '重力', translation: 'gravity'},
  {origin: '落下', translation: 'fall'}
]

def make_cards(japanese, english, book)
  card = Card.new
  card.book = book
  card.origin_word = japanese
  card.translation_word = english
  puts card
  card.save
end

puts 'Creating cards'
words.each do |word|
  Book.all.each do |book|
    make_cards(word[:origin], word[:translation], book)
  end
end
