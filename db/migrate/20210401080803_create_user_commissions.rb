class CreateUserCommissions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_commissions do |t|
      t.integer :user_id
      t.integer :share_order, default: 0
      t.integer :commission, default: 0
      t.integer :commission_wait, default: 0
      t.integer :commission_paid, default: 0
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
