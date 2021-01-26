class CreateBanners < ActiveRecord::Migration[5.2]
  def change
    create_table :banners do |t|
      t.string :status
      t.integer :priority, default: 1
      t.integer :product_id
      t.integer :attachment_id
      t.timestamps
    end
  end
end
