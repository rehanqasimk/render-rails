class AddPriceToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :price, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end
