class AddActiveToShoes < ActiveRecord::Migration[8.1]
  def change
    add_column :shoes, :active, :boolean, default: true, null: false
  end
end
