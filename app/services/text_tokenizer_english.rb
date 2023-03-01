require 'active_support/core_ext/string'
# Let's me use method singularize
class TextTokenizerEnglish
  def initialize(array)
    @array = array
  end

  def tokenize_all
    tokenized_arr = @array.map |text|
      tokenize(text)
    end
    tokenized_arr
  end

  def tokenize(text)
    # splits words along spaces, _, -, and /
    split_text = text.split(/[\s\-\_\/]/)
    # gets rid of non letters
    split_text_clean = split_text.map {|word| word.gsub(/(\W|\d)/, "")}
    # makes all words singular
    split_singular = split_text_clean.map {|word| word.singularize}
    # in case of nil, compact!
    split_singular.compact!
    # downcase the words
    words = split_singular.map {|word| word.downcase}

  end
end
