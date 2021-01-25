class CreateModelAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :model_attachments do |t|
      t.integer :model_id
      t.integer :attachment_id
      t.timestamps
    end
  end
end
