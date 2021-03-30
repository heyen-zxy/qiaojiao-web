class AddColumnDeleteAtToAllTables < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at

    add_column :companies, :deleted_at, :datetime
    add_index :companies, :deleted_at

    add_column :orders, :deleted_at, :datetime
    add_index :orders, :deleted_at

    add_column :categories, :deleted_at, :datetime
    add_index :categories, :deleted_at

    add_column :products, :deleted_at, :datetime
    add_index :products, :deleted_at

    add_column :admins, :deleted_at, :datetime
    add_index :admins, :deleted_at
  end
end
