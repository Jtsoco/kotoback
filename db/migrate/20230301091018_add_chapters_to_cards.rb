class AddChaptersToCards < ActiveRecord::Migration[7.0]
  def change
    add_column :cards, :chapter, :integer
    add_column :cards, :chapter_title, :string
  end
end
