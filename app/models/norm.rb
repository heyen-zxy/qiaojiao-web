class Norm < ApplicationRecord
  belongs_to :product
  validates_presence_of :price, :name
  validates :price,  inclusion: {in: 1..9999999999 }, if: Proc.new { |norm| norm.price.present? }

  def view_price
    price.to_f / 100
  end

end
