class CreateSizes < ActiveRecord::Migration[8.1]
  def change
    create_table :sizes do |t|
      t.string :label, null: false
      t.decimal :value_cm, null: false, precision: 5, scale: 2

      t.timestamps
    end
    add_index :sizes, :value_cm, unique: true
  end
end
