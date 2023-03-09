class JapaneseFilter
  def initialize (singular_words)
    @singular_words = singular_words
    @hiragana_katakana_regex = /[\u3040-\u309F]|[\u30A0-\u30FF]/
    @no_hiragana_katakana_regex = /[^\u3040-\u309F]|[^\u30A0-\u30FF]/
    @kanji = /[\u4E00-\u9FAF]/
    @filter_4000_common = []
    @filter_6000_common = File.foreach('lib/assets/japanese_filters/6000japanese_words.txt').map { |line| line.split(' ') }.flatten
    @filter_10000_common = File.foreach('lib/assets/japanese_filters/common_ja_10000.txt').map { |line| line.split(' ') }.flatten
    @newspaper_kanji = File.foreach('lib/assets/japanese_filters/newspaper_kanji.txt').map { |line| line.split(' ') }.flatten
  end

  def filter
    # @singular_words.reject {|singular| @hiragana_katakana_regex.match?(singular[0] && singular[0].length == 1)}
    # no_single_letters = @singular_words.reject {|singular| (@hiragana_katakana_regex.match?(singular[0]) && singular[0].length == 1)}
    # no_hiragana_katakana = no_single_letters. {|word| @no_hiragana_katakana_regex.match?(word[0])}
    kanji_words = @singular_words.select {|word| @kanji.match?(word[7])}
    # one word array for checking later
    one_word_version = kanji_words.map {|arr| arr[7]}
    # subtract all the filters from one_word_version, with -=
    # maybe put a count before this and implement it as the last part in each array
    # to save time
    # TODO
    one_word_version -= @filter_10000_common
    # count the unique words in teh non unique array
    unique_one_word = one_word_version.uniq

    unique_hash_array = unique_one_word.map do |word|
      number = one_word_version.count(word)
      {
        origin_word: word,
        count: number
      }
    end
    sorted_unique = unique_hash_array.sort_by {|hash| -hash.count}
    sorted_unique.each do |hash|
     arr = kanji_words.find{|arr| arr[7] == hash[:origin_word]}
     hash[:furigana] = arr[8]
    end
    # kanji_words.each {|arr| arr << one_word_version.count(arr[0])}
    # kanji_sorted = kanji_words.sort_by { |a| -a.last}
    # kanji_unique = kanji_sorted.uniq
    # kanji_popped = kanji_unique.map do |word|
    #   word.pop
    #   word
    # end
    # kanji_popped.uniq!
    # this should iterate over the unique, and count the equivalent words in the version that isn't unique, then put it into the end of the array at index 10
    # TODO reworkd this
    # final_filtered = kanji_popped.select {|arr| one_word_version.include?(arr[0])}
    # return it sorted, biggest to last
    return sorted_unique


  end


end
