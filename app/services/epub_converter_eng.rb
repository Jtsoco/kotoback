# require 'rubygems'
# require 'zip'
require "epub/parser"
require "cloudinary"

class EpubConverterEng
  def initialize(book)
    @book = book
  end

  def call

    # IMPORTANT!!!!!!!!!!
    # book_content.epub MUST be ignored in .gitignore!
    # IF NOT merging errors will sporadically occur!

    File.open("book_content.epub", "wb") do |file|
      # p url = Cloudinary::Utils.cloudinary_url(@book.manuscript.key) + '.epub'
      original_path = ApplicationController.helpers.cl_image_path @book.manuscript.key
      url = original_path.gsub("image", "raw")
      url += ".epub" unless url.match?(/\.epub/)
      file.write(URI.open(url).read())
    end

    # IMPORTANT!!!!!!!!!!
    # book_content.epub MUST be ignored in .gitignore!
    # IF NOT merging errors will sporadically occur!

    book = EPUB::Parser.parse("book_content.epub")
    book.metadata.titles # => Array of EPUB::Publication::Package::Metadata::Title. Main title, subtitle, etc...
    book.metadata.title # => Title string including all titles
    book.metadata.creators # => Creators(authors)

    def header(page)
      if page.content_document.nokogiri.search("h1").length.positive?
        @h = "h1"
      elsif page.content_document.nokogiri.search("h2").length.positive?
        @h = "h2"
      elsif page.content_document.nokogiri.search("h3").length.positive?
        @h = "h3"
      elsif page.content_document.nokogiri.search("h4").length.positive?
        @h = "h4"
      elsif page.content_document.nokogiri.search("h5").length.positive?
        @h = "h5"
      else
        @h = "h6"
      end
    end

    title = book.metadata.title
    Dir.mkdir("app/assets/manuscripts/#{title}") unless Dir.exist?("app/assets/manuscripts/#{title}")
    book.each_page_on_spine do |page|
      header(page)
      h_count = page.content_document.nokogiri.search("#{@h}").length
      p_count = page.content_document.nokogiri.search("p").length
      if h_count.positive? && p_count.positive?
        name = page.content_document.nokogiri.search("#{@h}").text
        name = name[0, 10] if name.length > 10
            File.open("app/assets/manuscripts/#{title}/#{name}.html", "w") do |file|
          file.write(page.content_document.nokogiri)
        end
        # File.join("app/assets/manuscripts/#{title}", "#{page.content_document.nokogiri.search("#{@h}").text}.html")
      end
      # @cloud.manuscript.purge
      # Cloudinary::Uploader.destroy("#{@book.manuscript.key}.epub", :resource_type => 'raw')
      # File.delete(*Dir["app/assets/manuscripts/#{title}/*"]) # Delete html files from the new book directory
      # Dir.rmdir("app/assets/manuscripts/#{title}")
    end
    File.delete(*Dir["book_content.epub"]) # Delete book.epub
    return title
  end
end

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
