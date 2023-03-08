class AddProcessingToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :processing, :boolean, default: true
  end
end
