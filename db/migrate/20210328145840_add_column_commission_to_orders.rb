class AddColumnCommissionToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :commission, :integer, default: 0
    add_column :orders, :commission_log_id, :integer
  end
end
