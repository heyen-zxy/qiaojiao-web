class AddColumnToUserCommissionLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :user_commission_logs, :commission_type, :integer
  end
end
