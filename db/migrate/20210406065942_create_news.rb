class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.string :content
      t.string :status
      t.timestamps
    end
  end
end
