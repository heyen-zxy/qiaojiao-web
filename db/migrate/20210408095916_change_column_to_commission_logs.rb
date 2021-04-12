class ChangeColumnToCommissionLogs < ActiveRecord::Migration[5.2]
  def change
    change_column :admin_commission_logs, :status, :integer
    change_column :user_commission_logs, :status, :integer
  end
end
