class FailedTodayFalseDefault < ActiveRecord::Migration[7.0]
  def change
    change_column :cards, :failed_today, :boolean, :default => false
  end
end
