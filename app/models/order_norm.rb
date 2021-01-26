class OrderNorm < ApplicationRecord
  belongs_to :product
  belongs_to :norm
  belongs_to :order

  def view_amount
    amount.to_f / 100
  end

  def view_price
    price.to_f / 100
  end
end
