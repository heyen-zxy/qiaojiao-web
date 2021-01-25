class ChangeColumnToProduct < ActiveRecord::Migration[5.2]
  def change
    rename_column :products, :type, :product_type
  end
end
