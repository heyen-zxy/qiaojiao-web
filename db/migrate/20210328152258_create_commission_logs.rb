class CreateCommissionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :commission_logs do |t|
      t.string :user_id
      t.integer :amount
      t.string :status
      t.string :commission_type
      t.text :desc
      t.timestamps
    end
  end
end
