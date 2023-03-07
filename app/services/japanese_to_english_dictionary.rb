class JapaneseToEnglishDictionary
  def initialize
    @dictionary = {}
    Eiwa.parse_file("lib/assets/dictionaries/JMdict_e.xml", type: :jmdict_e) do |entry|
      # possibility of nil exists, this checks for that
      if !entry.spellings.first.nil?
        japanese = entry.spellings.first.text
      end
      if !entry.meanings.first.definitions.first.nil?
        english =  entry.meanings.first.definitions.first.text
      end
      # only allow it to be added to hash if both exist
      if english && japanese
        @dictionary[japanese] = english
      end
      # TODO ADD FURIGANA FROM DICTIONARY
      # CHECK IF THIS IS FEASABLE ON LIVE
      # SEE IF THE DICTIONARY CAN'T BE ACCESSED FROM A CONSTANT
    end
  end
end
