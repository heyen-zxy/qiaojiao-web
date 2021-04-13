class AddColumnToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :attachment_id, :integer
    add_column :tags, :deleted_at, :datetime
  end
end
