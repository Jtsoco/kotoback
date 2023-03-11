class WordListCrossCheck
  def initialize(arrays)
    @arrays = arrays
  end

  def cross_check
    check_chapter = []
    checked_chapter = @arrays.map do |chapter|
      chapter -= check_chapter
      check_chapter += chapter
      chapter
    end
    checked_chapter
  end
end
