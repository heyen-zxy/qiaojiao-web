class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :target
      t.string :action
      t.text :desc
      t.timestamps
    end
  end
end
