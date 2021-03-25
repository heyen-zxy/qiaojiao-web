class AddColumnToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :sort_num, :integer, default: 0
  end
end
