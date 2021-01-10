class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string "authentication_token"
      t.string "code"
      t.integer "gender"
      t.string "nick_name"
      t.string "country"
      t.string "province"
      t.string "city"
      t.string "avatar_url"
      t.string "open_id"
      t.string "delete_at"
      t.string :session_token
      t.timestamps
    end
  end
end
