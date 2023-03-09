class TextTokenizerJapanese
  def initialize(array)
    @array = array
    @tagger = Suika::Tagger.new
    # this regex finds japanese
    # katakana, hiragana, and kanji
    # and ignores most punctuation
    # ( ) parenthesis must still be removed
    # take care, as it's the japanese keyboard parentheses, not western keyboard default
    @japanese_regex = /[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]/
  end
  def tokenize_all
    tokenized_arr = @array.map do |text|
      tokenize(text)
    end
    tokenized_arr
  end

  def tokenize(text)
    tokenized = tagger.parse(text).map {|token| token}
    tokenized_filtered = tokenized.map {|word| word.split(/[\s,]/)}
    japanese_only = tokenized_filtered.select{|arr| @regex.match?(arr[0])}
    # reject special parenthesis
    japanese_only_filtered = japanese_only.reject{|arr| arr[0].include?("（") || arr[0].include?("）")}
    japanese_only_filtered
  end
end
