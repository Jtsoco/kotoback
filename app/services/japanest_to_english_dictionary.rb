class JapaneseToEnglishDictionary
  def initialize
    @dictionary = {}
    Eiwa.parse_file("lib/assets/dictionaries/JMdict_e.xml", type: :jmdict_e) do |entry|
      if !entry.spellings.first.nil?
        japanese = entry.spellings.first.text
      end
      if !entry.meanings.first.definitions.first.nil?
        english =  entry.meanings.first.definitions.first.text
      end
      if english && japanese
        @dictionary[japanese] = english
      end
      # TODO ADD FURIGANA FROM DICTIONARY
      # CHECK IF THIS IS FEASABLE ON LIVE
      # SEE IF THE DICTIONARY CAN'T BE ACCESSED FROM A CONSTANT
    end
  end
end
