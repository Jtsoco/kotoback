# require 'rubygems'
# require 'zip'
require "epub/parser"
require "cloudinary"

class EpubConverter
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

    title = book.metadata.title
    Dir.mkdir("app/assets/manuscripts/#{title}") unless Dir.exist?("app/assets/manuscripts/#{title}")
    book.each_page_on_spine do |page|
      header_tag = header(page)
      headers = page.content_document.nokogiri.search(header_tag)
      doc = page.content_document.nokogiri
      # chapters = []
      headers.reverse.each_with_index do |header, index|
        next if header.attr("id").strip.blank?

        content = doc.search("##{header.attr("id")} ~ p")

        # if index == headers.length - 1
        #   p css_selector = "##{header.attr("id")} ~ p"
        #   debugger
        # else
        #   next_header = headers[index + 1]
        #   next if next_header.attr("id").strip.blank?
        #   content = content.search("p:not(##{next_header.attr("id")} ~ *)")
        #   p css_selector = "##{header.attr("id")} ~ p:not(##{next_header.attr("id")} ~ *)"
        # end
        # content = page.content_document.nokogiri.search(css_selector)
        next if content.empty?

        # chapters << {title: header.text, content: content.text }
        File.open("app/assets/manuscripts/#{title}/#{header.text}.html", "w") do |file|
          file.write(content)
        end
        # content.remove
        File.join("app/assets/manuscripts/#{title}", "#{header.text}.html")
      end

      # if h_count.positive? && p_count.positive?
      #   File.open("app/assets/manuscripts/#{title}/#{page.content_document.nokogiri.search("#{@h}").text}.html", "w") do |file|
      #     file.write(page.content_document.nokogiri)
      #   end
        # File.join("app/assets/manuscripts/#{title}", "#{page.content_document.nokogiri.search("#{@h}").text}.html")
      # end
      # @cloud.manuscript.purge
      # Cloudinary::Uploader.destroy("#{@book.manuscript.key}.epub", :resource_type => 'raw')
      # File.delete(*Dir["app/assets/manuscripts/#{title}/*"]) # Delete html files from the new book directory
      # Dir.rmdir("app/assets/manuscripts/#{title}")
    end
    File.delete(*Dir["book_content.epub"]) # Delete book.epub
    return title
  end

  private

  def header(page)
    6.times do |i|
      header_tag = "h#{6-i}"
      return header_tag if page.content_document.nokogiri.search(header_tag).any?
    end
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
