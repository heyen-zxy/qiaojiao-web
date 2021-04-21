class CreateAgents < ActiveRecord::Migration[5.2]
  def change
    create_table :agents do |t|
      t.string :province
      t.string :city
      t.string :county
      t.string :name
      t.string :company_name
      t.string :address
      t.string :phone
      t.integer :admin_id
      t.timestamps
    end
  end
end
