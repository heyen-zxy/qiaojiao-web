class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :category_id
      t.string :ancestry
      t.integer :ancestry_depth, default: 0
      t.timestamps
    end
  end
end
