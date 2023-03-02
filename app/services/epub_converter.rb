# require 'rubygems'
# require 'zip'
require 'epub/parser'
require 'cloudinary'

class EpubConverter
  def initialize(book)
    @book = book
  end
  def call
    File.open("ebook.epub", "wb") do |file|
      # p url = Cloudinary::Utils.cloudinary_url(@book.manuscript.key) + '.epub'
      original_path = ApplicationController.helpers.cl_image_path @book.manuscript.key
      url = original_path.gsub("image", "raw")
      url += ".epub" unless url.match?(/.\epub/)
      file.write(URI.open(url).read())
    end

    book = EPUB::Parser.parse('ebook.epub')
    book.metadata.titles # => Array of EPUB::Publication::Package::Metadata::Title. Main title, subtitle, etc...
    book.metadata.title # => Title string including all titles
    book.metadata.creators # => Creators(authors)

    title = book.metadata.title
    Dir.mkdir("app/assets/manuscripts/#{title}") unless Dir.exist?("app/assets/manuscripts/#{title}")
    book.each_page_on_spine do |page|
      h1_count = page.content_document.nokogiri.search("h1").length
      p_count = page.content_document.nokogiri.search("p").length
      if h1_count.positive? && p_count.positive?
        page.content_document
        File.open("app/assets/manuscripts/#{title}/#{page.content_document.nokogiri.search("h1").text}.html", "w") do |file|
        # File.open("app/assets/manuscripts/#{title}/test5.html", "w") do |file|
        # File.new("app/assets/manuscripts/#{title}/test3.html", "w") do |file|
          file.write(page.content_document.nokogiri)
        end
        File.join("app/assets/manuscripts/#{title}", "#{page.content_document.nokogiri.search("h1").text}.html")
        # File.join("app/assets/manuscripts/#{title}", 'test5.html')
      end
      # p page.content_document.nokogiri.children.first
    end
  end
end

  # def call
  #   reader = Epub::Reader.open("https://res.cloudinary.com/dickg3cpz/raw/upload/v1677638616/development/a7q18g5za80qc265phton8pl5ut6.epub")
  #   puts reader.epub_version
  #   puts reader.title
  #   puts reader.author
  #   puts reader.publication_date
  #   puts reader.language
  #   reader.pages.each do |page|
  #     puts page.title
  #     puts page.content
  #   end
  # end

# folder = "Users/me/Desktop/stuff_to_zip"
# input_filenames =

# zipfile_name = "/Users/me/Desktop/archive.zip"

# Zip::File.open(zipfile_name, create: true) do |zipfile|
#   input_filenames.each do |filename|
#     # Two arguments:
#     # - The name of the file as it will appear in the archive
#     # - The original file, including the path to find it
#     zipfile.add(filename, File.join(folder, filename))
#   end
#   zipfile.get_output_stream("myFile") { |f| f.write "myFile contains just this" }
# end
