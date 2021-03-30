class AddColumnToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments,  :apply_res, :text
    add_column :payments,   :prepay_id, :string
    add_column :payments,   :response_data, :text
  end
end
