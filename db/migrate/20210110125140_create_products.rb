class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.integer :category_id
      t.string :type
      t.string :name
      t.string :status
      t.integer :sale, default: 0
      t.float :commission
      t.text :desc
      t.timestamps
    end
  end
end
