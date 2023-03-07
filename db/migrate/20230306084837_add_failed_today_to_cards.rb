class AddFailedTodayToCards < ActiveRecord::Migration[7.0]
  def change
    add_column :cards, :failed_today, :boolean
  end
end
