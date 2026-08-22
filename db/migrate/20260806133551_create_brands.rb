class CreateBrands < ActiveRecord::Migration[8.1]
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    add_index :brands, :name, unique: true
  end
end
