class AddColumnLanguagePairToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :language_pair, :integer, default: 0
  end
end
