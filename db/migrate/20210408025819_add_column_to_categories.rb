class AddColumnToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :ancestry_depth, :integer, default: 0
    add_column :products, :tag_id, :integer
  end
end
