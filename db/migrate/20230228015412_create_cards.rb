class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.references :book, null: false, foreign_key: true
      t.string :origin_word
      t.string :origin_definition
      t.string :furigana
      t.string :translation_word
      t.string :translation_definition
      t.string :example_sentence
      t.string :pronunciation

      t.timestamps
    end
  end
end
