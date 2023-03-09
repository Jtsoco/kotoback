class JapaneseFilter
  def initialize (singular_words)
    @singular_words = singular_words
    @hiragana_katakana_regex = /[\u3040-\u309F]|[\u30A0-\u30FF]/
    @no_hiragana_katakana_regex = /[^\u3040-\u309F]|[^\u30A0-\u30FF]/
    @filter_4000_common = []
    @filter_6000_common = File.foreach('lib/assets/japanese_filters/6000japanese_words.txt').map { |line| line.split(' ') }.flatten
    @newspaper_kanji = File.foreach('lib/assets/japanese_filters/newspaper_kanji.txt').map { |line| line.split(' ') }.flatten
  end

  def filter
    # @singular_words.reject {|singular| @hiragana_katakana_regex.match?(singular[0] && singular[0].length == 1)}
    no_single_letters = @singular_words.reject {|singular| (@hiragana_katakana_regex.match?(singular[0]) && singular[0].length == 1)}
    # one word array for checking later
    one_word_version = no_single_letters.map {|arr| arr[0]}
    # subtract all the filters from one_word_version, with -=
    # maybe put a count before this and implement it as the last part in each array
    # to save time
    # TODO
    one_word_version -= @filter_6000_common
    # count the unique words in teh non unique array
    unique_singular = no_single_letters.uniq
    # this should iterate over the unique, and count the equivalent words in the version that isn't unique, then put it into the end of the array at index 10
    unique_singular.each {|arr| arr << no_single_letters.count(arr)}
    final_filtered = unique_singular.select {|arr| one_word_version.include?(arr[0])}
    # return it sorted, biggest to last
    final_filtered.sort_by { |a| -a.last}

  end


end
