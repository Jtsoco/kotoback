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
    @punctuation_regex = /[（）？！]/
  end
  def tokenize_all
    tokenized_arr = @array.map do |text|
      tokenize(text)
    end
    tokenized_arr
  end

  def tokenize(text)
    @tagger.parse(text).map do |word|
      spliced = word.split("\t").last.split(",")
      {
        origin_word: spliced[6],
        furigana: spliced[7]
      }
    end
  end
end
