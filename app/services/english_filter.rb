class EnglishFilter

  def initialize(singular_words)
    # add filters={} as an intialize option later
    # for filter select
    # an array of singular words from the text
    @singular_words = singular_words
    # This is where we put the filter options
    # we will have multiple options per language
    # we will have one main function to run through filters
    # and it will apply them based on which filters are true
    # Next is adding specific filter arrays as variables
    @stop_words = File.foreach('app/assets/filters/english_filters/stop_words.txt').map { |line| line.split(' ') }.flatten
    # don't want to set singular, want to remove contractions as is
    @contractions = File.foreach('app/assets/filters/english_filters/contractions.txt').map { |line| line.split(' ') }.flatten
    @top_names = File.foreach('app/assets/filters/english_filters/top_names.txt').map { |line| line.split(' ') }.flatten
    # this is the 1000 most common english words
    @english_1000 = set_singular(File.foreach('app/assets/filters/english_filters/english_1000.txt').map { |line| line.split(' ') }.flatten)
    @english_10000 = set_singular(File.foreach('app/assets/filters/english_filters/english_10000.txt').map { |line| line.split(' ') }.flatten)
  end



  def set_singular(split_text)
    # split_text = text.split(/(\\n)|[\s\-\_\/]/)
    # gets rid of non letters
    split_text_clean = split_text.map {|word| word.gsub(/(\W|\d)/, "")}
    # makes all words singular
    split_singular = split_text_clean.map {|word| word.singularize}
    split_singular.uniq!
    words = split_singular.reject{|w| w.empty?}
    # reject 1 and 2 letter words
    words = words.reject{|w| w.length.between?(1,2)}

    # in case of nil, compact!
    words.compact!
    # downcase the words
    words.map {|word| word.downcase}
  end

  def filter
    singular_words = @singular_words.map{ |word| word.downcase}
    singular_words -= @stop_words
    singular_words -= @top_names
    split_text =  singular_words - @contractions
    split_clean = split_text.map {|word| word.gsub(/(\W|\d)/, "")}
    # split_text = text.split(/(\\n)|[\s\-\_\/]/)
    # gets rid of non letters
    # makes all words singular
    words = split_clean.map {|word| word.singularize}
    # reject 1 and 2 letter words
    words = words.reject{|w| w.length.between?(1,2)}
    # downcase the words
    unique_words = words.uniq
    unique_words = unique_words.reject {|word| word.empty?}
    # make a hash with word count
    # in case of nil, compact!
    unique_words.compact!
    @contractions.each do |word|
      # noticed a pattern in dracula,
      # where contractions lose the t to make
      # an accent. This accounts for some of that
      word = word.gsub("n't", "")
      unique_words = unique_words.reject {|unique| unique.include?(word)}
    end
    # get rid of most common english words
    unique_words -= @english_10000

    unique_array = unique_words.map do |unique|
      {
        count: words.count(unique),
        word: unique
      }
    end
    # give back an array of hashes, pertaining to the count
    unique_array.sort_by { |h| -h[:count]}
  end

end
