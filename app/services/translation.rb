class Translation
  def initialize(array, source_lang, target_lang)
    @array = array
    @source_lang = source_lang
    @target_lang = target_lang
  end

  def translate
    translation = DeepL.translate(@array, @source_lang, @target_lang)
    hash_array = @array.map.with_index do |word, index|
      {
        origin_word: word,
        translation_word: translation[index].text,
      }
    end
    return hash_array
  end
end
