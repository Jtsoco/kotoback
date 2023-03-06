class AddCompletedTodayToCards < ActiveRecord::Migration[7.0]
  def change
    add_column :cards, :completed_today, :boolean
  end
end
