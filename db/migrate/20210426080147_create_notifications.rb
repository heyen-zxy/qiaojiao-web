class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :order_id
      t.text :content
      t.text :resp
      t.integer :status
      t.timestamps
    end
  end
end
