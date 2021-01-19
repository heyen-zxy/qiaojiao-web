class AddColumnToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :tag, :string
    add_column :resources, :name, :string
  end
end
