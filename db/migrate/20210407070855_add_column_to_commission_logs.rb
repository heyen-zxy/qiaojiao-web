class AddColumnToCommissionLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :user_commission_logs, :status, :string
    add_column :admin_commission_logs, :status, :string
    add_column :admin_commission_logs, :operation_id, :integer
    add_column :orders, :admin_commission, :integer
  end
end
