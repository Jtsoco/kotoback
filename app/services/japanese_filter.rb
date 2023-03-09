class JapaneseFilter
  def initialize (singular_words)
    @singular_words = singular_words
    @hiragana_katakana_regex = /[\u3040-\u309F]|[\u30A0-\u30FF]/
    @no_hiragana_katakana_regex = /[^\u3040-\u309F]|[^\u30A0-\u30FF]/
  end

  def filter
    # @singular_words.reject {|singular| @hiragana_katakana_regex.match?(singular[0] && singular[0].length == 1)}
    no_single_letters = @singular_words.reject {|singular| (@hiragana_katakana_regex.match?(singular[0]) && singular[0].length == 1)}
  end


end
