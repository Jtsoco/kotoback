class AddDefaultToCompleted < ActiveRecord::Migration[7.0]
  def change
    change_column :cards, :completed_today, :boolean, :default => false
  end
end
