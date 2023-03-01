require 'active_support/core_ext/string'
# Let's me use method singularize
class TextTokenizerEnglish
  def initialize(array)
    @array = array
    @contractions = File.foreach('app/assets/filters/english_filters/contractions.txt').map { |line| line.split(' ') }.flatten

  end

  def tokenize_all
    tokenized_arr = @array.map |text|
      tokenize(text)
    end
    tokenized_arr
  end

  def tokenize(text)
    # splits words along spaces, _, -, and /
    text.squish!
    split_text = text.split(/(\\n)|[\W_\d]/)
    split_text.reject{|w| w.empty?}
  end
end
