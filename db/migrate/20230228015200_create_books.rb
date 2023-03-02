class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :chapters
      t.references :user, null: false, foreign_key: true
      t.string :genre
      t.string :image_urlw

      t.timestamps
    end
  end
end
