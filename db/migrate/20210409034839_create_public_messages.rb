class CreatePublicMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :public_messages do |t|
      t.string :status
      t.text :content
      t.integer :valid_days
      t.datetime :deleted_at
      t.string :phone
      t.integer :message_type_id
      t.string :name
      t.integer :user_id
      t.timestamps
    end
  end
end
