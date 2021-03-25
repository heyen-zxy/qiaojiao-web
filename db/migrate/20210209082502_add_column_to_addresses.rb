class AddColumnToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :default, :boolean, default: false
  end
end
