class EpubParser #change name to HTMLParser
  def initialize(folder)
    @folder = folder
  end

  def parse_chapters
   chapters = Dir.glob("app/assets/manuscripts/#{@folder}/**/*.html")
   chapter_texts = chapters.map do |chapter|
    Nokogiri::XML(open(chapter)).text
   end
   chapter_texts
   end
end
# require 'nokogiri'

# # doc = Nokogiri::HTML(open('Famous_Modern_Ghost_Stories.html'))
# # this gets all the id tags and puts them in an array
# # id_tags = doc.xpath('//@id')
# # puts id_tags
# # first = id_tags[3]
# # puts first
# # willows = doc.xpath("//a[@id='Willows']/")
# # puts willows

# # doc2 = Nokogiri::HTML(open('Warbreaker_BrandonSanderson-rev1b-1/index_split_024.html'))
# # puts doc2.text
# puts "parsing done"
# # Dir.foreach('/pg345') do |filename|
# #   puts filename
# # end

# # This gives me the path of all html files in the folder beneath
# # if using irb, press q to escape irb hell
# list = Dir.glob("pg345/**/*.html")
# list2 = Dir.glob("Warbreaker_BrandonSanderson-rev1b-1/**/*.html")
# puts list
# doc = Nokogiri::HTML(open("Warbreaker_BrandonSanderson-rev1b-1/index_split_040.html")).text
# # this will give me full text document of the above

# text_arr = list.map do |item|
#   Nokogiri::HTML(open(item)).text
# end
# puts text_arr
