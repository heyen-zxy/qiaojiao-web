class AddColumnToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :no, :string
    add_column :products, :amount, :integer, default: 0
  end
end
