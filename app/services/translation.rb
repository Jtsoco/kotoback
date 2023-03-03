class Translation
  def initialize(array, source_lang, target_lang)
    @array = array
    @source_lang = source_lang
    @target_lang = target_lang
  end

  def translate
    translation = DeepL.translate(@array, @source_lang, @target_lang)
    if translation.is_a?(Array) && !@array.empty?
      hash_array = @array.map.with_index do |word, index|
        {
          origin_word: word,
          translation_word: translation[index].text,
        }
      end
    elsif @array.length == 0
      # TODO remove empty hashes from array after this
      hash_array = []
      hash_array << {}
    else
      # TODO refactor this so that it isn't as patchwork
      hash_array = []
      hash_array << {
        origin_word: @array.first,
        translation_word: translation,
      }
    end

    return hash_array
  end
end
