class CreateShoeVariants < ActiveRecord::Migration[8.1]
  def change
    create_table :shoe_variants do |t|
      t.references :shoe, null: false, foreign_key: true
      t.references :size, null: false, foreign_key: true
      t.decimal :price, null: false, precision: 10, scale: 2
      t.integer :stock_quantity, null: false, default: 0

      t.timestamps
    end
    add_index :shoe_variants, [ :shoe_id, :size_id ], unique: true
  end
end
