class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string "no"
      t.integer "amount"
      t.string "status"
      t.integer "user_id"
      t.datetime "payment_at"
      t.integer "address_id"
      t.text "desc"
      t.integer :admin_id
      t.datetime "server_at"
      t.timestamps
    end
  end
end
