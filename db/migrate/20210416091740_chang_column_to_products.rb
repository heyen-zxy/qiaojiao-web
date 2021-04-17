class ChangColumnToProducts < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :commission, :float, default: 0
    change_column :products, :high_commission, :float, default: 0
    change_column :products, :admin_commission, :float, default: 0
  end
end
