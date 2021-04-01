class CreateUserCommissionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :user_commission_logs do |t|
      t.integer :user_commission_id
      t.integer :order_id
      t.integer :user_id
      t.integer :commission
      t.integer :commission_before, default: 0
      t.integer :commission_after, default: 0
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
