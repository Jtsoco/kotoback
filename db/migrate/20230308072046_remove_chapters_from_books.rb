class RemoveChaptersFromBooks < ActiveRecord::Migration[7.0]
  def change
    remove_column :books, :chapters
  end
end
