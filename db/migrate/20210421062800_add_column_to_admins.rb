class AddColumnToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :agent_id, :integer
  end
end
