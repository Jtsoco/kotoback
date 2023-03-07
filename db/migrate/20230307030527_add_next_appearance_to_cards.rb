class AddNextAppearanceToCards < ActiveRecord::Migration[7.0]
  def change
    add_column :cards, :next_appearance, :datetime, default: DateTime.now.beginning_of_day
  end
end
