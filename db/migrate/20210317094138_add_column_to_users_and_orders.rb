class AddColumnToUsersAndOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :share_user_id, :integer
    add_column :users, :share_token, :string
  end
end
