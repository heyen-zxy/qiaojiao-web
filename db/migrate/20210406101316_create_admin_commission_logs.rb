class CreateAdminCommissionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_commission_logs do |t|
      t.integer :admin_commission_id
      t.integer :order_id
      t.integer :admin_id
      t.integer :commission
      t.integer :commission_before, default: 0
      t.integer :commission_after, default: 0
      t.text :desc
      t.integer :commission_type
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
