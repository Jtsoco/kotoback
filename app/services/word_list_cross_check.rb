class WordListCrossCheck
  def initialize(arrays)
    @arrays = arrays
  end

  def cross_check
    check_array = []
    checked_array = @arrays.map do |array|
      array -= check_array
      check_array += array
      array
    end
    checked_array
  end
end
