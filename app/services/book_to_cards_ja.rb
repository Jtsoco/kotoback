class BookToCardsJa < ApplicationJob
  queue_as :default

  def perform(book)
    card_creator(book)
  end
  def card_creator(book) #name pending
    # make the local directory
    epub_converter = EpubConverterEng.new(book)
    title = epub_converter.call
    # calling the epub converter here instead of the controller
    # title = book.metadata.title
    epub_parser = EpubParser.new(title)
    chapter_texts = epub_parser.parse_chapters
    File.delete(*Dir["app/assets/manuscripts/#{title}/*"]) # Delete html files from the new book directory
    Dir.rmdir("app/assets/manuscripts/#{title}")
    text_tokenizer_japanese = TextTokenizerJapanese.new(chapter_texts)
    tokenized_hashes = text_tokenizer_japanese.tokenize_all
    filtered_arrays = tokenized_hashes.map do |tokenized_hash|
      japanese_filter = JapaneseFilter.new(tokenized_hash)
      japanese_filter.filter
    end

    word_list_cross_check = WordListCrossCheck.new(filtered_arrays)
    checked_arrays = word_list_cross_check.cross_check

    translated_chapter_arrays = checked_arrays.map do |chapter|
      if chapter.empty?
        # TODO improve this
      else

        translation = TranslateJapanese.new(chapter, "JA", "EN")
        translation.translate
      end
    end
    translated_chapter_arrays.compact!
    book.title = title
    book.save
    translated_chapter_arrays.each_with_index do |array, index|
      array.each do |hash|
        new_card(hash, index, book)
      end
    end
    # book.processing = false
    # book.save
    # fetch_book_cover = FetchBookCover.new(book)
    # fetch_book_cover.set_book_cover
  end


  def new_card(hash, index, book)
    card = Card.new
    card.origin_word = hash[:origin_word]
    card.translation_word = hash[:translation_word]
    card.furigana = hash[:furigana]
    card.chapter = index + 1
    card.book = book
    card.save
  end
end
