class AddColumnAdminCommissionToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :admin_commission, :integer, default: 0
  end
end
