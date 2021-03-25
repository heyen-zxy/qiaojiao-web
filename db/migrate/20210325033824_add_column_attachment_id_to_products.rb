class AddColumnAttachmentIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :main_attachment_id, :integer
    add_column :products, :high_commission, :integer
    add_column :users, :company_id, :integer
  end
end
