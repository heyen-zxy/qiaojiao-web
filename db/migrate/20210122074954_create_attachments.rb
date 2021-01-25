class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.string :type
      t.string :file_path
      t.string :file_name
      t.timestamps
    end
  end
end
