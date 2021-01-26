class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :address_code
      t.string :desc
      t.integer :user_id
      t.string :phone
      t.string :name
      t.timestamps
    end
  end
end
