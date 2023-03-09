class TranslateJapanese
  def initialize(chapter, source_lang, target_lang)
    @chapter = chapter
    @source_lang = source_lang
    @target_lang = target_lang
  end
  def translate
    # grab the first word of each nested array
    # TODO check if it's better to put dictionary word into the translation
    single_word_array = @chapter.map {|word| word[0]}
    translation = DeepL.translate(single_word_array, @source_lang, @target_lang)
    if translation.is_a?(Array) && !@chapter.empty?
      hash_array = single_word_array.map.with_index do |word, index|
        {
          origin_word: word,
          translation_word: translation[index].text,
          furigana: @chapter[index][8],
          dictionary: @chapter[index][7],
        }
      end
    elsif @array.length == 0
      hash_array = []
      hash_array << {}
    else
      hash_array = []
      hash_array << {
        origin_word: @single_word_array.first,
        translation_word: translation
      }
    end
    return hash_array
  end
end
