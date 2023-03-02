class BookToCards
  # TODO make other versions of this class, for different origin languages
  # add an attribute for transation language in initialize
  def initialize(book)
    # this book is the instance of a book
    @book = book
  end

  def card_creator #name pending
    # make the local directory
    epub_converter = EpubConverter.new(@book)
    epub_converter.call
    # calling the epub converter here instead of the controller
    title = @book.metadata.title
    epub_parser = EpubParser.new(title)
    chapter_texts = epub_parser.parse_chapters
    # Now we should have an array of chapter texts
    text_tokenizer_english = TextTokenizerEnglish.new(chapter_texts)
    tokenized_arrays = text_tokenizer_english.tokenize_all
    filtered_arrays = tokenized_arrays.map do |tokenized_array|
      english_filter = EnglishFilter.new(tokenized_array)
      filter_hash_array = english_filter.filter
    end
    tranlsated_chapter_arrays = filtered_arrays.map do |chapter|
      chapter_words = chapter.map do |hash|
        hash[:word]
      end
      translation = Translation.new(chapter_words, "EN", "JA")
      translation_hashes = translation.translate
    end
    return tranlsated_chapter_arrays
  end
end
