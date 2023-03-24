# require 'rubygems'
# require 'zip'
require "epub/parser"
require "cloudinary"

class EpubConverterJa  
  def initialize(book)
    @book = book
  end

  # >>>>>>>>>start of test version 
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
      chapter_regex = /プロローグ|(第|\u7B2C)*([\u4e00]|[\u4E8C]|[\u4E09]|[\u56DB]|[\u4e94]|[\u516D]|[\u4E03]|[\u516B]|[\u4E5D]|[\u5341]|[\u767e])(場|\u5834)*|エピローグ/
      if page.content_document.nokogiri.search("h1").any? && page.content_document.nokogiri.search("h1").text.match?(chapter_regex)
        @h = "h1"
      elsif page.content_document.nokogiri.search("h2").any? && page.content_document.nokogiri.search("h2").text.match?(chapter_regex)
        @h = "h2"
      elsif page.content_document.nokogiri.search("h3").any? && page.content_document.nokogiri.search("h3").text.match?(chapter_regex)
        @h = "h3"
      elsif page.content_document.nokogiri.search("h4").any? && page.content_document.nokogiri.search("h4").text.match?(chapter_regex)
        @h = "h4"
      elsif page.content_document.nokogiri.search("h5").any? && page.content_document.nokogiri.search("h5").text.match?(chapter_regex)
        @h = "h5"
      # elsif page.content_document.nokogiri.search("h6").any? && page.content_document.nokogiri.search("h6").text.match?(/\d*\s*chapter\s*\d*|prologue|epilogue|\d*/i)
        # @h = "h6"
      else
        @h = "h6"
      end
    end

    $title = book.metadata.title #using a global variable at the moment, need to check if there is a better solution to access this variable in the book_to_cards service
    chapter_texts = []
    book.each_page_on_spine do |page|
      header(page)
      h_count = page.content_document.nokogiri.search("#{@h}")
      p_count = page.content_document.nokogiri.search("p")
      if h_count.any? && p_count.any?
          chapter_texts << page.content_document.nokogiri.text
      end
    end
    File.delete(*Dir["book_content.epub"]) # Delete book.epub
    return chapter_texts #issue as we also need to read the title in another service, need to find a way to use both the title variable and chapter_texts.
  end
end
# >>>>>>>>>>>>>>>>> end of test version

# >>>>>>>>>>>>>>>start of previous version that worked
#   def call

#     # IMPORTANT!!!!!!!!!!
#     # book_content.epub MUST be ignored in .gitignore!
#     # IF NOT merging errors will sporadically occur!

#     File.open("book_content.epub", "wb") do |file|
#       # p url = Cloudinary::Utils.cloudinary_url(@book.manuscript.key) + '.epub'
#       original_path = ApplicationController.helpers.cl_image_path @book.manuscript.key
#       url = original_path.gsub("image", "raw")
#       url += ".epub" unless url.match?(/\.epub/)
#       file.write(URI.open(url).read())
#     end

#     # IMPORTANT!!!!!!!!!!
#     # book_content.epub MUST be ignored in .gitignore!
#     # IF NOT merging errors will sporadically occur!

#     book = EPUB::Parser.parse("book_content.epub")
#     book.metadata.titles # => Array of EPUB::Publication::Package::Metadata::Title. Main title, subtitle, etc...
#     book.metadata.title # => Title string including all titles
#     book.metadata.creators # => Creators(authors)

#     def header(page)
#       if page.content_document.nokogiri.search("h1").any? #&& page.content_document.nokogiri.search("h1").text.match?(/\d*\s*chapter\s*\d*|prologue|epilogue|\d*/i)
#         @h = "h1"
#       elsif page.content_document.nokogiri.search("h2").any? #&& page.content_document.nokogiri.search("h2").text.match?(/\d*\s*chapter\s*\d*|prologue|epilogue|\d*/i)
#         @h = "h2"
#       elsif page.content_document.nokogiri.search("h3").any? #&& page.content_document.nokogiri.search("h3").text.match?(/\d*\s*chapter\s*\d*|prologue|epilogue|\d*/i)
#         @h = "h3"
#       elsif page.content_document.nokogiri.search("h4").any? #&& page.content_document.nokogiri.search("h4").text.match?(/\d*\s*chapter\s*\d*|prologue|epilogue|\d*/i)
#         @h = "h4"
#       elsif page.content_document.nokogiri.search("h5").any? #&& page.content_document.nokogiri.search("h5").text.match?(/\d*\s*chapter\s*\d*|prologue|epilogue|\d*/i)
#         @h = "h5"
#       # elsif page.content_document.nokogiri.search("h6").any?
#       #   @h = "h6"
#       else
#         @h = "h6"
#       end
#     end

#     title = book.metadata.title
#     Dir.mkdir("app/assets/manuscripts/#{title}") unless Dir.exist?("app/assets/manuscripts/#{title}")
#     book.each_page_on_spine do |page|
#       header(page)
#       h_count = page.content_document.nokogiri.search("#{@h}")
#       p_count = page.content_document.nokogiri.search("p")
#       if h_count.any? && p_count.any?
#         name = page.content_document.nokogiri.search("#{@h}").text
#         name = name[0, 10] if name.length > 10
#             File.open("app/assets/manuscripts/#{title}/#{name}.html", "w") do |file|
#           file.write(page.content_document.nokogiri)
#         end
#         # File.join("app/assets/manuscripts/#{title}", "#{page.content_document.nokogiri.search("#{@h}").text}.html")
#       end
#       # @cloud.manuscript.purge
#       # Cloudinary::Uploader.destroy("#{@book.manuscript.key}.epub", :resource_type => 'raw')
#       # File.delete(*Dir["app/assets/manuscripts/#{title}/*"]) # Delete html files from the new book directory
#       # Dir.rmdir("app/assets/manuscripts/#{title}")
#     end
#     File.delete(*Dir["book_content.epub"]) # Delete book.epub
#     return title
#   end
# end
# >>>>>>>>>>>> end of previous version that worked

# elsif page.content_document.nokogiri.search("h6").any? && page.content_document.nokogiri.search("h6").text.match?(/\bchapter/i)
  # @h = "h6"

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
