require 'active_support/core_ext/string'
# Let's me use method singularize
class TextTokenizerEnglish
  def initialize(array)
    @array = array
    # @contractions = File.foreach('app/assets/filters/english_filters/contractions.txt').map { |line| line.split(' ') }.flatten

  end

  def tokenize_all
    tokenized_arr = @array.map |text|
      tokenize(text)
    end
    tokenized_arr
  end

  def tokenize(text)
    # squish gets rid of html content like \n in the text
    text.squish!
    # note to self, change regex beneath later. Get rid of \n, squish already does it
    # TODO
    split_text = text.split(/(\\n)|[\W_\d]/)
    split_text.reject{|w| w.empty?}
  end
end
