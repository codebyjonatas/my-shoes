class CreateShoes < ActiveRecord::Migration[8.1]
  def change
    create_table :shoes do |t|
      t.string :name, null: false
      t.text :description
      t.string :gender, null: false
      t.references :brand, null: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :shoes, [ :name, :brand_id ], unique: true
  end
end
