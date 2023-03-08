class BookToCards < ApplicationJob
  # TODO make other versions of this class, for different origin languages
  # add an attribute for transation language in initialize
  queue_as :default



  def perform(books)
    card_creator(books)
  end

  def card_creator(books) #name pending
    # make the local directory
    epub_converter = EpubConverter.new(books)
    title = epub_converter.call
    # calling the epub converter here instead of the controller
    # title = @books.metadata.title
    epub_parser = EpubParser.new(title)
    chapter_texts = epub_parser.parse_chapters
    # Now we should have an array of chapter texts
    text_tokenizer_english = TextTokenizerEnglish.new(chapter_texts)
    tokenized_arrays = text_tokenizer_english.tokenize_all
    filtered_arrays = tokenized_arrays.map do |tokenized_array|
      english_filter = EnglishFilter.new(tokenized_array)
      filter_hash_array = english_filter.filter.first(50)
      # grabbing the first 50, only those that are most common
      # of the rare words per chapter
      # they come out ordered by english filter
    end
    # turn the hashes back into words... could probably do in filter?
    filtered_arrays_sans_hash = filtered_arrays.map do |chapter|
      chapter_words = chapter.map do |hash|
        hash[:word]
      end
      chapter_words
    end
    # check the lists of all chapters against previous chapters
    word_list_cross_check = WordListCrossCheck.new(filtered_arrays_sans_hash)
    checked_arrays = word_list_cross_check.cross_check
    # TODO just translate word arrays of checked chapters
    translated_chapter_arrays = checked_arrays.map do |chapter|
      if chapter.empty?
        # TODO FIX THIS
      else

      translation = Translation.new(chapter, "EN", "JA")
      translation_hashes = translation.translate
      end
    end
    # remove nil arrays from quick fix
    translated_chapter_arrays.compact!
    # TODO put in check for empty arrays
    books.title = title
    books.save
    # have to use the title to set books cover
    fetch_book_cover = FetchBookCover.new(books)
    fetch_book_cover.set_book_cover
    translated_chapter_arrays.each_with_index do |array, index|
      array.each do |hash|
        new_card(hash, index, books)
      end
    end
    File.delete(*Dir["app/assets/manuscripts/#{title}/*"]) # Delete html files from the new books directory
    Dir.rmdir("app/assets/manuscripts/#{title}")

  end

  def new_card(hash, index, books)
    card = Card.new
    card.origin_word = hash[:origin_word]
    card.translation_word = hash[:translation_word]
    card.chapter = index + 1
    card.book = books
    card.save
  end
end
