class CreatePaymentLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_logs do |t|
      t.string :payment_id
      t.text :apply_res
      t.string :prepay_id
      t.text :response_data
      t.timestamps
    end
  end
end
